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
    params = fleet.name + "(#{ fleet.production_status }%)" if fleet.in_production?
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
  	info = "<b>#{fleet.name}</b>"
  	info << " (Custo: #{fleet.credits}, #{fleet.producing_time} turnos)"
  	case fleet.type
  	when 'CapitalShip'
  	  info << "<br>- Carga: #{fleet.used_capacity} / #{fleet.capacity} tons"
      info << "<br>- Abordagem / Captura de Fabricas"
      info << "<br>- Armamento de Unidades"
  	when 'Facility'
      info << "<br>- Producao / Treinamento de Unidades"
  	end
    info << "<br>- Construindo... (#{ fleet.production_status }%)" if fleet.in_production?
  	info
  end

end
