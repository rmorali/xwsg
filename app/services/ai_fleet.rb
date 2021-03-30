class AiFleet
  def initialize(*squad)
    @squad = squad.first unless squad.nil?
    @setup = Setup.current
    @round = Round.current
  end

  def act!
    return unless @squad.ai == true
    fleets = Fleet.where(ai: true, squad: @squad)

    if @squad.credits > 1200
      chance_of_build = rand(@squad.ai_level..6)
      build! if chance_of_build == 6
    end

    facilities = fleets.select { |fleet| fleet.type == 'Facility'}
    credits_for_producing = @squad.credits
    credits_for_producing = @squad.credits / facilities.count unless facilities.empty?
    facilities.each do |facility|
      produce!(facility, credits_for_producing) unless @round.number == 1
    end

    carriers = fleets.select { |fleet| fleet.available_capacity > 10 && fleet.type != 'Facility' }
    carriers.each do |carrier|
      embark!(carrier)
    end

    fleets = Fleet.where(ai: true, squad: @squad)

    fleets.each do |fleet|
      arm!(fleet)
    end

    fleets.each do |fleet|
      move!(fleet)
    end
    @squad.ready!
  end

  def produce!(facility, available)
    for_capital_ships = available * 0.40
    for_transports = available * 0.20
    for_fighters = available * 0.40
    planet = facility.planet
    squad = facility.squad
    until for_capital_ships < 600 do
      capital_ships = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'CapitalShip', for_capital_ships)
      capital_ship = capital_ships[rand(capital_ships.count)] unless capital_ships.empty?
      BuildFleet.new(1, capital_ship, squad, planet).build! unless capital_ship.nil?
      for_capital_ships -= capital_ship.credits
    end
    until for_transports < 125 do
      transports = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'LightTransport', for_transports)
      transport = transports[rand(transports.count)] unless transports.empty?
      BuildFleet.new(1, transport, squad, planet).build! unless transport.nil?
      for_transports -= transport.credits
    end
    fighters = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Fighter', for_fighters)
    fighter = fighters[rand(fighters.count)] unless fighters.empty?

    BuildFleet.new( (for_fighters / fighter.credits).to_i, fighter, squad, planet ).build! unless fighter.nil?

    GroupFleet.new(planet).group!
  end

  def embark!(fleet)
    cargo = fleet.carriables
    cargo.each do |c|
      ShipFleet.new(c.quantity, c, fleet).embark!
    end
    GroupFleet.new(fleet.planet).group!
  end

  def move!(fleet)
    return unless fleet.movable? || fleet.carrier
    planet = fleet.planet
    routes = Route.in_range_for(fleet)
    attack = 6
    attack = rand(@squad.ai_level..6) if planet.fleets.any? { |f| f.squad == @squad && f.type == 'Facility' }
    if attack == 6
      destination = choose_destination(routes)
      MoveFleet.new(fleet, fleet.quantity, destination).order!
    end
    GroupFleet.new(fleet.planet).group!
  end

  def build!
    planets = Planet.seen_by(@squad).reject { |p| p.fleets.any? { |f| f.type == 'Facility' } }
    planet = planets[rand(planets.count)] unless planets.empty?
    facilities = Unit.allowed_for(@squad.faction.name).where("type = ? AND credits <= ?", 'Facility', @squad.credits)
    facility = facilities[rand(facilities.count)] unless facilities.empty?
    BuildFleet.new(1, facility, @squad, planet).build! unless facility.nil? || planet.nil?
  end

  def arm!(fleet)
    arm = rand(1..3)
    if arm == 1
      armaments = Unit.allowed_for(fleet.squad.faction.name).where("type = ?", 'Armament')
      armament = armaments[rand(armaments.count)]
    else
      armament = nil
    end
    fleet.update(armament: armament ) unless fleet.armament != nil || fleet.type != "LightTransport"
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
