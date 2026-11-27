module ApplicationHelper
  def show(fleet)
    params = format_unit_label(fleet)
    params << " [#{fleet.production_status}%]" if fleet.in_production?
    params << " +#{fleet.armament.acronym}" if fleet.armament
    params << " [RADAR]" if fleet.radar?
    params
  end

  def show_fog(fleet)
    params = if fleet.in_production?
               "#{fleet.name} [#{fleet.production_status}%]"
             elsif non_groupable?(fleet)
               format_unit_label(fleet)
             else
               "#{fleet.final_quantity} #{fleet.name}"
             end
    params << " +#{fleet.armament.acronym}" if fleet.armament
    params << " [RADAR]" if fleet.radar?
    params
  end

  def style(fleet)
    squad_color = fleet.squad.color.presence || '#e2e8f0'
    styles = ["color: #{squad_color};"]

    case fleet.type
    when 'CapitalShip'
      styles << 'font-weight: 700; font-size: 11px; letter-spacing: 0.3px;'
    when 'Facility'
      styles << "font-weight: 700; font-size: 11px; border: 1px solid #{squad_color}; border-radius: 3px; padding: 1px 5px; background: rgba(15, 23, 42, 0.9); display: inline-block; margin-bottom: 2px;"
    when 'Warrior'
      styles << "font-weight: 700; font-style: italic; font-size: 11px; letter-spacing: 0.4px; text-shadow: 0 0 6px #{squad_color};"
    else
      styles << 'font-weight: 500; font-size: 11px;'
    end

    styles << 'border: 1px dashed rgba(250, 204, 21, 0.7); padding: 1px 4px; border-radius: 3px; opacity: 0.85;' if fleet.in_production?
    styles.join(' ')
  end

  def tip(fleet)
    setups = Setup.current
    lines = []
    lines << "<div style='border-bottom: 1px solid rgba(56,189,248,0.3); padding-bottom: 4px; margin-bottom: 4px;'>"
    lines << "<strong style='color: #38bdf8; font-size: 12px;'>#{fleet.name.upcase}</strong>"
    lines << "<br><span style='color: #94a3b8; font-size: 10px;'>Custo: #{fleet.credits} cr | Tempo: #{fleet.producing_time}t | Influência: #{fleet.influence}</span>"
    lines << "</div>"

    case fleet.type
    when 'CapitalShip'
      lines << "<div>• <b>Carga:</b> #{fleet.used_capacity} / #{fleet.capacity} tons</div>"
      lines << "<div>• <b>Nível Tático:</b> #{fleet.level}</div>"
      lines << "<div>• <b>Capacidade:</b> Abordagem / Captura de Fábricas</div>"
    when 'Facility'
      lines << "<div>• <b>Função:</b> Produção / Treinamento de Unidades</div>"
    when 'Warrior'
      lines << "<div>• <b>Nível Tático:</b> #{fleet.level}</div>"
      lines << "<div>• <b>Massa:</b> #{fleet.weight} tons</div>"
    when 'LightTransport', 'HeavyTransport'
      lines << "<div>• <b>Carga:</b> #{fleet.used_capacity} / #{fleet.capacity} tons</div>"
      lines << "<div>• <b>Capacidade:</b> Abordagem / Captura de Fábricas</div>"
    when 'Fighter'
      lines << "<div>• <b>Massa:</b> #{fleet.weight} tons</div>"
    end

    lines << "<div style='color: #facc15;'>• <b>Armamento:</b> #{fleet.armament.name}</div>" if fleet.armament
    lines << "<div style='color: #4ade80;'>• <b>Armorial:</b> Reabastece Unidades</div>" if fleet.armory?
    lines << "<div style='color: #fbbf24;'>• <b>Status:</b> Em Construção/Reparo (#{fleet.production_status}%)</div>" if fleet.in_production?

    if (fleet.builder? && fleet.type != 'Facility') || (fleet.type == setups.builder_unit && fleet.type == 'Facility')
      lines << "<div style='color: #38bdf8;'>• <b>Unidade Construtora</b> (Mínimo: #{setups.minimum_fleet_for_build})</div>"
    end

    if fleet.respond_to?(:description) && fleet.description.present?
      lines << "<div style='margin-top: 5px; padding-top: 4px; border-top: 1px dashed rgba(56,189,248,0.35); color: #e2e8f0; white-space: normal;'><b>Identificação:</b> #{ERB::Util.html_escape(fleet.description)}</div>"
    end

    if fleet.unit.description.present?
      lines << "<div style='margin-top: 5px; padding-top: 4px; border-top: 1px dashed rgba(148,163,184,0.25); color: #cbd5e1; font-style: italic; white-space: normal;'>#{fleet.unit.description}</div>"
    end

    lines.join
  end

  def show_result(fleet)
    info = +''
    if fleet.class.name == 'Result'
      if fleet.round != @round
        info << " [#{fleet.blasted}d]" if fleet.blasted.to_i > 0
        info << " [#{fleet.fled}f]" if fleet.fled.to_i > 0
        info << " [#{fleet.captured}c]" if fleet.captured.to_i > 0
        info << " (Capturado: #{fleet.captor.name})" if fleet.captor
      end
    elsif fleet.results.any?
      result = fleet.results.last
      if result.round == @round
        info << " [#{result.blasted}d]" if result.blasted.to_i > 0
        info << " [#{result.fled}f]" if result.fled.to_i > 0
        info << " [#{result.captured}c]" if result.captured.to_i > 0
      end
    end
    info
  end

  private

  def format_unit_label(fleet)
    if fleet.type == 'Warrior' && fleet.respond_to?(:description) && fleet.description.present?
      warrior_name = fleet.description.to_s[/\A\s*([^\s.]+)/, 1]
      warrior_name.present? ? "#{fleet.name} '#{warrior_name}'" : fleet.name.dup
    elsif non_groupable?(fleet)
      fleet.name.dup
    else
      "#{fleet.quantity} #{fleet.name}"
    end
  end

  def non_groupable?(fleet)
    if fleet.respond_to?(:groupable?)
      !fleet.groupable?
    elsif fleet.respond_to?(:unit) && fleet.unit.respond_to?(:groupable?)
      !fleet.unit.groupable?
    else
      %w[CapitalShip Facility Warrior].include?(fleet.type)
    end
  end
end