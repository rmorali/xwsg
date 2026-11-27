require 'net/http'
require 'json'
require 'uri'
require 'openssl'
require 'resolv'

class GeminiNarrativeService
  BASE_URL        = 'https://generativelanguage.googleapis.com/v1beta/models'.freeze
  FALLBACK_MODELS = %w[gemini-2.5-flash-lite gemini-2.0-flash gemini-3.8-flash].freeze

  SYSTEM_PROMPT = <<~PROMPT.freeze
    Você é o Cronista Oficial da HoloNet Galáctica redigindo boletins militares de uma campanha no universo de Star Wars.
    Sua tarefa é escrever o resumo do turno atual de combate em português do Brasil, mantendo continuidade com os turnos anteriores.

    Regras obrigatórias:
    1. Baseie-se ESTRITAMENTE nos relatórios de batalha (BattleReports) e resultados táticos (Results) fornecidos. Nunca invente batalhas, planetas ou baixas que não aconteceram.
    2. Cite explicitamente as quantidades exatas de baixas e perdas de unidades de cada esquadrão/lado envolvido nos confrontos.
    3. Use o histórico dos turnos anteriores apenas para continuidade narrativa (retomadas de planetas, revanches, avanço de frotas), sem repetir o texto dos capítulos passados.
    4. Adote um tom jornalístico militar, direto e objetivo, com terminologia autêntica de Star Wars (hiperespaço, turbolasers, escudos, torpedos de prótons), evitando excesso de adjetivos ou floreios literários.
    5. Escreva um título curto de transmissão da HoloNet na primeira linha, seguido de 1 a 3 parágrafos objetivos cobrindo os eventos e baixas do turno atual.
    6. Retorne apenas texto limpo separado por parágrafos (sem blocos de código ou marcações markdown).
  PROMPT

  def initialize(round = nil)
    @round = round || Round.current
  end

  def generate!
    return nil unless @round

    briefing = build_campaign_briefing
    return save_narrative('Nenhum confronto ou movimentação relevante foi registrado nos sensores neste ciclo.') if briefing.blank?

    api_key = Rails.application.credentials.dig(:gemini, :api_key) || ENV['GEMINI_API_KEY']
    return save_narrative('Transmissão da HoloNet indisponível: chave da API do Gemini não configurada.') if api_key.blank?

    narrative_text = request_with_resilience(api_key, briefing)
    return nil if narrative_text.blank?

    save_narrative(narrative_text.strip)
  rescue StandardError => e
    Rails.logger.error("[GeminiNarrativeService] Falha ao gerar narrativa do Turno #{@round&.number}: #{e.class} - #{e.message}")
    nil
  end

  private

  def build_campaign_briefing
    current_results = Result.where(round: @round).includes(fleet: [:unit, :squad, :planet]).to_a
    all_reports = BattleReport.where('round_id <= ?', @round.id)
                              .includes(:round, :squad)
                              .order(round_id: :asc, squad_id: :asc)
                              .to_a

    return '' if current_results.empty? && all_reports.empty?

    lines = []

    past_reports = all_reports.select { |br| br.round.number < @round.number }
    if past_reports.any?
      lines << '=== HISTÓRICO DA CAMPANHA (TURNOS ANTERIORES - APENAS CONTEXTO DE CONTINUIDADE) ==='
      past_reports.group_by { |br| br.round.number }.sort_by { |num, _| num }.each do |round_num, reports|
        lines << "\n[Turno #{round_num}]"
        reports.each do |br|
          squad_name = br.squad&.name || 'Esquadrão'
          lines << "- #{squad_name}: #{br.content}" if br.content.present?
        end
      end
    end

    lines << "\n=== EVENTOS DO TURNO ATUAL (TURNO #{@round.number} - NARRAR ESTE CAPÍTULO) ==="

    current_reports = all_reports.select { |br| br.round_id == @round.id }
    if current_reports.any?
      lines << "\n--- RELATÓRIOS DE BATALHA DO TURNO #{@round.number} (BATTLE REPORTS) ---"
      current_reports.each do |br|
        squad_name = br.squad&.name || 'Esquadrão'
        faction_name = br.squad&.faction&.name
        header = faction_name.present? ? "#{squad_name} (#{faction_name})" : squad_name
        lines << "• #{header}: #{br.content}" if br.content.present?
      end
    end

    if current_results.any?
      lines << "\n--- RESULTADOS TÁTICOS DAS FROTAS NO TURNO #{@round.number} (RESULTS) ---"
      current_results.group_by { |r| r.fleet&.planet&.name || 'Setor Desconhecido' }.each do |planet_name, results|
        lines << "Setor #{planet_name}:"
        results.each do |res|
          fleet = res.fleet
          next unless fleet

          squad_name = fleet.squad&.name || 'Desconhecido'
          unit_name  = fleet.unit&.name || 'Unidade'
          details = res.attributes
                       .except('id', 'fleet_id', 'round_id', 'created_at', 'updated_at')
                       .reject { |_, v| v.blank? || v == 0 }
                       .map { |k, v| "#{k}: #{v}" }
                       .join(', ')

          lines << "  - [#{squad_name}] #{fleet.quantity}x #{unit_name} (#{details})"
        end
      end
    end

    lines.join("\n")
  end

  def request_with_resilience(api_key, briefing)
    discovered = discover_flash_models(api_key)
    models_to_try = (discovered + FALLBACK_MODELS).uniq

    models_to_try.each do |model|
      text = try_model(model, api_key, briefing)
      return text if text.present?
    end

    nil
  end

  def try_model(model, api_key, briefing)
    2.times do |attempt|
      status, body = post_to_gemini(model, api_key, briefing)

      if status == 200
        text = JSON.parse(body).dig('candidates', 0, 'content', 'parts', 0, 'text')
        if text.present?
          Rails.logger.info("[GeminiNarrativeService] Narrativa gerada com sucesso usando #{model}")
          return text
        end
      elsif [429, 503, 504].include?(status)
        Rails.logger.warn("[GeminiNarrativeService] #{model} indisponível/lento (HTTP #{status}), tentativa #{attempt + 1}...")
        sleep(1)
      else
        Rails.logger.error("[GeminiNarrativeService] #{model} HTTP #{status}: #{body}")
        break
      end
    end
    nil
  end

  def post_to_gemini(model, api_key, briefing)
    uri = URI("#{BASE_URL}/#{model}:generateContent?key=#{api_key}")
    http = build_http(uri, read_timeout: 55)

    payload = {
      systemInstruction: {
        parts: [{ text: SYSTEM_PROMPT }]
      },
      contents: [
        {
          role: 'user',
          parts: [{ text: "Escreva a narrativa oficial do Turno #{@round.number} considerando todo o contexto abaixo:\n\n#{briefing}" }]
        }
      ],
      generationConfig: {
        temperature: 0.75,
        maxOutputTokens: 1500
      }
    }

    request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json', 'Connection' => 'close')
    request.body = payload.to_json

    response = http.request(request)
    [response.code.to_i, response.body]
  rescue Net::ReadTimeout, Net::OpenTimeout => e
    Rails.logger.warn("[GeminiNarrativeService] Timeout em #{model}: #{e.class}")
    [504, e.message]
  end

  def discover_flash_models(api_key)
    uri = URI("#{BASE_URL}?key=#{api_key}")
    http = build_http(uri, read_timeout: 15)
    response = http.request(Net::HTTP::Get.new(uri.request_uri))
    return [] unless response.is_a?(Net::HTTPSuccess)

    models = JSON.parse(response.body)['models'] || []
    flash_names = models.select do |m|
      name = m['name'].to_s.downcase
      methods = m['supportedGenerationMethods'] || []
      name.include?('flash') &&
        %w[image audio tts robotics computer].none? { |excluded| name.include?(excluded) } &&
        methods.include?('generateContent')
    end.map { |m| m['name'].sub('models/', '') }

    flash_names.sort_by do |name|
      score = 10
      score -= 4 if name.include?('lite')
      score -= 2 if name.include?('2.5') || name.include?('2.0')
      score += 3 if name.include?('preview') || name.include?('exp')
      score
    end
  rescue StandardError
    []
  end

  def build_http(uri, read_timeout: 55)
    http = Net::HTTP.new(uri.host, uri.port)
    http.ipaddr = resolve_ipv4(uri.host)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if Gem.win_platform?
    http.open_timeout = 10
    http.read_timeout = read_timeout
    http
  end

  def resolve_ipv4(host)
    Resolv::DNS.open do |dns|
      record = dns.getresource(host, Resolv::DNS::Resource::IN::A)
      record.address.to_s
    end
  rescue StandardError
    nil
  end

  def save_narrative(text)
    @round.update!(narrative: text)
    text
  end
end