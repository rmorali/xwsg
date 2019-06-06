module FleetHelper
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
      params << "font-weight: bold; font-size: 14px"
    end
    params
  end
end
