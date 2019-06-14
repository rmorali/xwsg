class AiFleet
  def initialize(*squad)
    @squad = squad.first unless squad.nil?
    @setup = Setup.current
  end

  def act!
    return unless @squad.ai == true
    fleets = Fleet.where(ai: true, squad: @squad)
    carriers = fleets.select { |fleet| fleet.available_capacity > 10 && fleet.type != 'Facility' }
    carriers.each do |carrier|
      embark!(carrier)
    end 
    fleets.each do |fleet|
      move!(fleet)
    end
    @squad.ready!
  end

  def produce

  end

  def embark!(fleet)
    cargo = fleet.carriables
    cargo.each do |c|
      ShipFleet.new(c.quantity, c, fleet).embark!
    end
  end

  def move!(fleet)
    return unless fleet.movable?
    planet = fleet.planet
    routes = Route.in_range_for(fleet)
    attack = 6
    attack = rand(@squad.ai_level..6) if planet.fleets.any? { |f| f.squad == @squad && f.type == 'Facility' }
    if attack == 6
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
