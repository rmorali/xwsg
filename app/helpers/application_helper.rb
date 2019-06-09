module ApplicationHelper
  def show(fleet)
	case fleet.type
	when 'CapitalShip'
	  fleet.name
	when 'Facility'
	  fleet.name
	else
	  "#{fleet.quantity} #{fleet.name}"
	end
  end

  def style(fleet)
	params = "color: #{fleet.squad.color}; "
	case fleet.type
	when 'CapitalShip'
	  params << "font-weight: bold; font-size: 12px"
	when 'Facility'
	  params << "font-weight: bold; font-size: 14px; border-radius: 0%; border: solid 1px; padding: 0px; background-color: #111111"
	end
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
	info
  end

end
