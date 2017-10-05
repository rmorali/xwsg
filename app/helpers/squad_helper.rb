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

  def quantity(fleet)
  	fleet.quantity if fleet.groupable
  end

  def style(fleet)
  	style = []
  	style << "color: #{ fleet.squad.color }; font-weight: bold; font-size: 70%; text-align: center; margin: auto; width: 3%;"
  	style.join(' ')
  end
end
