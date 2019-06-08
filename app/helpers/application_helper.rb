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

  def style_fog(fleet)
	params = "color: #{fleet.squad.color}; opacity: 0.3;"
	case fleet.type
	when 'CapitalShip'
		params << "font-weight: bold; font-size: 12px"
	when 'Facility'
		params << "font-weight: bold; font-size: 14px"
	end
	params
  end
end
