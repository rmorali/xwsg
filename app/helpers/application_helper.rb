module ApplicationHelper
  def show(fleet)
  	case fleet.type
  	when 'CapitalShip'
  	  params = fleet.name
  	when 'Facility'
  	  params = fleet.name
  	else
  	  params = "#{fleet.quantity} #{fleet.name}"
  	end
    params << "(#{ fleet.production_status }%)" if fleet.in_production?
    params << " + #{ fleet.armament.acronym }" if fleet.armament
    params << " + R" if fleet.radar?
    params
  end

  def show_fog(fleet)
    case fleet.type
    when 'CapitalShip'
      params = fleet.name
    when 'Facility'
      params = fleet.name
    else
      params = "#{fleet.final_quantity} #{fleet.name}"
    end
    params = fleet.name + "(#{ fleet.production_status }%)" if fleet.in_production?
    params << " + #{ fleet.armament.acronym }" if fleet.armament
    params << " + R" if fleet.radar?
    params
  end

  def style(fleet)
  	params = "color: #{fleet.squad.color}; "
  	case fleet.type
  	when 'CapitalShip'
  	  params << "font-weight: bold; font-size: 12px;"
  	when 'Facility'
  	  params << "font-weight: bold; font-size: 13px; border-radius: 0%; border: solid 1px; padding: 0px; background-color: #111111;"
  	end
    params << "border: dashed 1px" if fleet.in_production?
  	params
  end

  def tip(fleet)
    setups = Setup.current
  	info = "<b>#{fleet.name}</b>"
  	info << " (Custo: #{fleet.credits}, Turnos: #{fleet.producing_time}) "
    info << "<br>- Influência: #{fleet.influence}"
  	case fleet.type
  	when 'CapitalShip'
  	  info << "<br>- Carga: #{fleet.used_capacity} / #{fleet.capacity} tons"
      info << "<br>- Nivel: #{fleet.level}"
      info << "<br>- Abordagem / Captura de Fabricas"
  	when 'Facility'
      info << "<br>- Producao / Treinamento de Unidades"
    when 'LightTransport'
      info << "<br>- Carga: #{fleet.used_capacity} / #{fleet.capacity} tons"
      info << "<br>- Abordagem / Captura de Fabricas"
    when 'HeavyTransport'
      info << "<br>- Carga: #{fleet.used_capacity} / #{fleet.capacity} tons"
      info << "<br>- Abordagem / Captura de Fabricas"
    when 'Fighter'
      info << "<br>- Peso: #{fleet.weight} tons"
  	end
    info << "<br>- Armamento: #{fleet.armament.name}" if fleet.armament
    info << "<br>- (Armorial) Armamento de Unidades" if fleet.armory?
    info << "<br>- Em Construção / Reparo ... ( #{ fleet.production_status }% pronto)" if fleet.in_production?
    info << "<br>- Unidade Construtora ( Mínimo: #{setups.minimum_fleet_for_build} )" if fleet.builder? && fleet.type != 'Facility'
    info << "<br>- Unidade Construtora ( Mínimo: #{setups.minimum_fleet_for_build} )" if fleet.type == setups.builder_unit && fleet.type == 'Facility'
    info << "<br>- #{fleet.unit.description}" if fleet.unit.description

  	info
  end

  def show_result(fleet)
    round = Round.current
    info = ""
    if fleet.class.name == 'Result'
      info << "#{fleet.blasted}d " if fleet.blasted.to_i > 0 && fleet.round != @round
      info << "#{fleet.fled}f " if fleet.fled.to_i > 0 && fleet.round != @round
      info << "#{fleet.captured}c " if fleet.captured.to_i > 0 && fleet.round != @round
      info << "by #{fleet.captor.name}" if fleet.captor && fleet.round != @round
    else
      unless fleet.results.empty?
        result = fleet.results.last
        info << "#{result.blasted}d " if result.blasted.to_i > 0 && result.round == @round
        info << "#{result.fled}f " if result.fled.to_i > 0 && result.round == @round
        info << "#{result.captured}c " if result.captured.to_i > 0 && result.round == @round
      end
    end
    info
  end

end
