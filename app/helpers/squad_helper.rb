module SquadHelper
	  def adjust_x(sector)
    case sector
    when 1, 4, 7
      return 0
    when 2, 5, 8
      return 33
    when 3, 6, 9
      return 66
    end
  end

  def adjust_y(sector)
    case sector
    when 1, 2, 3
      return 0
    when 4, 5, 6
      return 33
    when 7, 8, 9
      return 66
    end
  end

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
