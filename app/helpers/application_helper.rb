module ApplicationHelper
  def quantity(fleet)
    fleet.quantity if fleet.groupable
  end

  def style(fleet)
    style = []
    style << "color: #{fleet.squad.color}; font-weight: bold; font-size: 60%; text-align: center; margin: auto;"
    style << if fleet.groupable
               'width: 3%; height: 3%;'
             else
               'width: 4%; height: 3%;'
             end

    style.join(' ')
  end
end
