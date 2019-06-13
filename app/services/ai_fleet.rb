class AiFleet
  def initialize(*squad)
    @squad = squad.first unless squad.nil?
    @setup = Setup.current
  end

  def act!
    return unless @squad.ai == true
    fleets = Fleet.where(ai: true, squad: @squad)
    fleets.each do |fleet|
      move!(fleet)
    end
    @squad.ready!
  end

  def produce

  end

  def move!(fleet)
    return unless fleet.movable?
    planet = fleet.planet
    routes = Route.in_range_for(fleet)
    stay_defending = 6
    stay_defending = rand(@squad.ai_level..6) if planet.fleets.any? { |f| f.squad == @squad && f.type == 'Facility' }
    unless stay_defending != 6
      destination = choose_destination(routes)
      MoveFleet.new(fleet, fleet.quantity, destination).order!
    end
  end

  def build

  end

  def choose_destination(routes)
    enemy_planets = routes.select { |route| route.fleets.any? { |fleet| fleet.squad != @squad } }
    if enemy_planets.empty? || @squad.ai_level <= 3
      destination = routes[rand(routes.count)]
    else
      destination = enemy_planets[rand(enemy_planets.count)]
    end
    destination
  end

end
