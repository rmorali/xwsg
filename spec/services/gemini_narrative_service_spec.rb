require 'rails_helper'

RSpec.describe GeminiNarrativeService, type: :service do
  let!(:round_1) { create(:round, number: 1) }
  let!(:round_2) { create(:round, number: 2) }
  let(:service) { described_class.new(round_2) }
  let(:http_double) { instance_double(Net::HTTP) }

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:gemini, :api_key).and_return('test-api-key')
    allow(Net::HTTP).to receive(:new).and_return(http_double)
    allow(http_double).to receive(:ipaddr=)
    allow(http_double).to receive(:use_ssl=)
    allow(http_double).to receive(:verify_mode=)
    allow(http_double).to receive(:open_timeout=)
    allow(http_double).to receive(:read_timeout=)
    allow(service).to receive(:sleep)
  end

  describe '#generate!' do
    context 'when there are no battle reports or results for the round' do
      it 'saves a default quiet-cycle message without calling the Gemini API' do
        expect(Net::HTTP).not_to receive(:new)

        result = service.generate!

        expect(result).to eq('Nenhum confronto ou movimentação relevante foi registrado nos sensores neste ciclo.')
        expect(round_2.reload.narrative).to eq('Nenhum confronto ou movimentação relevante foi registrado nos sensores neste ciclo.')
      end
    end

    context 'when the Gemini API key is missing' do
      before do
        create(:battle_report, round: round_2, content: 'Patrulha em Coruscant.')
        allow(Rails.application.credentials).to receive(:dig).with(:gemini, :api_key).and_return(nil)
        allow(ENV).to receive(:[]).and_call_original
        allow(ENV).to receive(:[]).with('GEMINI_API_KEY').and_return(nil)
      end

      it 'saves an unavailable API message' do
        expect(Net::HTTP).not_to receive(:new)

        result = service.generate!

        expect(result).to eq('Transmissão da HoloNet indisponível: chave da API do Gemini não configurada.')
        expect(round_2.reload.narrative).to eq('Transmissão da HoloNet indisponível: chave da API do Gemini não configurada.')
      end
    end

    context 'when battle reports and combat results exist' do
      let(:planet) { create(:planet, name: 'Endor') }
      let(:imperial_squad) { create(:squad, name: 'Esquadrão Tempestade') }
      let(:rebel_squad) { create(:squad, name: 'Aliança Rebelde') }

      let(:star_destroyer_unit) { create(:unit, name: 'Imperial Star Destroyer', groupable: false) }
      let(:xwing_unit) { create(:unit, name: 'X-Wing', groupable: true) }

      let!(:named_fleet) do
        create(:fleet,
               unit: star_destroyer_unit,
               squad: imperial_squad,
               planet: planet,
               round: round_2,
               quantity: 1,
               description: 'ISD Executor, capitânia do Lorde Vader')
      end

      let!(:unnamed_fleet) do
        create(:fleet,
               unit: xwing_unit,
               squad: rebel_squad,
               planet: planet,
               round: round_2,
               quantity: 12,
               description: nil)
      end

      before do
        create(:battle_report, round: round_1, squad: imperial_squad, content: 'Frota reunida em Kuat.')
        create(:battle_report, round: round_2, squad: imperial_squad, content: 'Bloqueio orbital iniciado em Endor.')
        create(:result, round: round_2, fleet: named_fleet)
        create(:result, round: round_2, fleet: unnamed_fleet)
      end

      it 'includes fleet descriptions, current reports, and past history in the prompt and saves the narrative' do
        models_response = instance_double(Net::HTTPSuccess, body: {
          models: [
            { name: 'models/gemini-2.5-flash-lite', supportedGenerationMethods: ['generateContent'] },
            { name: 'models/gemini-2.5-flash-image', supportedGenerationMethods: ['generateContent'] }
          ]
        }.to_json)
        allow(models_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

        generate_response = instance_double(Net::HTTPResponse, code: '200', body: {
          candidates: [
            { content: { parts: [{ text: "BOLETIM HOLONET - SETOR ENDOR\n\nO ISD Executor liderou o cerco orbital." }] } }
          ]
        }.to_json)

        captured_payload = nil
        allow(http_double).to receive(:request) do |req|
          if req.is_a?(Net::HTTP::Get)
            models_response
          else
            captured_payload = JSON.parse(req.body)
            generate_response
          end
        end

        narrative = service.generate!

        prompt_text = captured_payload.dig('contents', 0, 'parts', 0, 'text')
        expect(prompt_text).to include('Frota reunida em Kuat.')
        expect(prompt_text).to include('Bloqueio orbital iniciado em Endor.')
        expect(prompt_text).to include('[Esquadrão Tempestade] 1x Imperial Star Destroyer [ISD Executor, capitânia do Lorde Vader]')
        expect(prompt_text).to include('[Aliança Rebelde] 12x X-Wing (')

        expect(narrative).to eq("BOLETIM HOLONET - SETOR ENDOR\n\nO ISD Executor liderou o cerco orbital.")
        expect(round_2.reload.narrative).to eq(narrative)
      end

      it 'falls back to the next available model when the primary model fails with HTTP 429' do
        models_response = instance_double(Net::HTTPSuccess, body: {
          models: [
            { name: 'models/gemini-2.5-flash-lite', supportedGenerationMethods: ['generateContent'] },
            { name: 'models/gemini-2.0-flash', supportedGenerationMethods: ['generateContent'] }
          ]
        }.to_json)
        allow(models_response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)

        rate_limit_response = instance_double(Net::HTTPResponse, code: '429', body: 'Too Many Requests')
        success_response = instance_double(Net::HTTPResponse, code: '200', body: {
          candidates: [
            { content: { parts: [{ text: 'BOLETIM HOLONET - FALLBACK OK' }] } }
          ]
        }.to_json)

        post_calls = 0
        allow(http_double).to receive(:request) do |req|
          if req.is_a?(Net::HTTP::Get)
            models_response
          else
            post_calls += 1
            post_calls <= 2 ? rate_limit_response : success_response
          end
        end

        expect(service.generate!).to eq('BOLETIM HOLONET - FALLBACK OK')
        expect(post_calls).to eq(3)
      end
    end

    context 'when an unexpected exception occurs' do
      before do
        create(:battle_report, round: round_2, content: 'Ataque surpresa.')
        allow(http_double).to receive(:request).and_raise(StandardError, 'Socket closed')
      end

      it 'logs the error and returns nil gracefully' do
        expect(Rails.logger).to receive(:error).with(/Falha ao gerar narrativa do Turno 2/)
        expect(service.generate!).to be_nil
      end
    end
  end
end