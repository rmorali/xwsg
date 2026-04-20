class AiFleet
  def initialize(*squad)
    @squad = squad.first unless squad.nil?
    @setup = Setup.current
    @round = Round.current
    @smartness = @squad.ai_level || 3 
    @aggressiveness = @squad.ai_level || 3
    @targeted_planets = [] 
  end

  def act!
    return unless @squad.ai == true
    
    fleets = Fleet.where(squad: @squad)

    if @squad.credits > 1200
      chance_of_build = rand(@squad.ai_level..7)
      build! if chance_of_build == 7
    end

    facilities = fleets.select { |fleet| fleet.unit.type == 'Facility'}
    credits_for_producing = @squad.credits
    credits_for_producing = @squad.credits / facilities.count unless facilities.empty?
    
    facilities.each do |facility|
      produce!(facility, credits_for_producing) unless @round.number == 1
    end

    carriers = fleets.select { |fleet| fleet.available_capacity > 10 && fleet.unit.type != 'Facility' }
    carriers.each do |carrier|
      embark!(carrier)
    end

    fleets.each { |fleet| arm!(fleet) }

    planets_with_fleets = fleets.map(&:planet).uniq
    planets_with_fleets.each do |planet|
      planet_fleets = fleets.select { |f| f.planet == planet && f.movable? && f.carrier.nil? }
      dispatch_task_force!(planet, planet_fleets) unless planet_fleets.empty?
    end

    @squad.ready!
  end

  private

  def dispatch_task_force!(planet, planet_fleets)
    attack_threshold = 7 - @aggressiveness
    will_attack = rand(1..6) >= attack_threshold || planet_in_danger?(planet)
    
    return unless will_attack

    reachable_planets = Route.in_range_for(planet_fleets.first)
    return if reachable_planets.empty?

    destination = choose_destination(reachable_planets, planet_fleets)
    return if destination.nil?

    capital_ships = planet_fleets.select { |f| f.unit.type == 'CapitalShip' }
    fighters = planet_fleets.select { |f| f.unit.type == 'Fighter' }
    transports = planet_fleets.select { |f| f.unit.type == 'LightTransport' }

    # RULE 1 CORRIGIDA: Deixar a MENOR guarnição possível de Fighters OU Transports
    has_facility = planet.fleets.joins(:unit).where(squad: @squad, units: { type: 'Facility' }).any?
    
    if has_facility
      # Une Fighters e Transports como candidatos a defensores
      garrison_candidates = fighters + transports
      
      if garrison_candidates.any?
        # A IA inteligente deixa apenas a menor frota para trás, liberando o esquadrão principal
        defender = garrison_candidates.min_by(&:quantity)
        planet_fleets -= [defender]
        fighters -= [defender] if defender.unit.type == 'Fighter'
        transports -= [defender] if defender.unit.type == 'LightTransport'
      end
    end

    # RULE 3 CORRIGIDA: Evita enviar naves capitais sem escolta (Contando caças embarcados!)
    if capital_ships.any? && @smartness >= 3
      travelling_fighters = fighters.sum(&:quantity)
      
      # Caças que estão dentro dos transportes também contam como escolta!
      embarked_fighters = transports.any? ? Fleet.joins(:unit).where(carrier: transports, units: { type: 'Fighter' }).sum(:quantity) : 0
      
      total_escorts = travelling_fighters + embarked_fighters
      total_capitals = capital_ships.sum(&:quantity)
      
      if total_escorts < (total_capitals * 2)
        planet_fleets -= capital_ships 
      end
    end

    # Se todas as naves ficaram na defesa ou abortaram, cancela o movimento
    return if planet_fleets.empty?

    planet_fleets.each do |fleet|
      MoveFleet.new(fleet, fleet.quantity, destination).order!
    end

    GroupFleet.new(planet).group!
  end

  def produce!(facility, available)
    planet = facility.planet
    squad = facility.squad
    
    current_capitals = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'CapitalShip' }).sum(:quantity)
    current_fighters = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'Fighter' }).sum(:quantity)
    current_transports = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'LightTransport' }).sum(:quantity)
    
    budget = available

    if current_capitals == 0 && budget >= 600
      capital_budget = budget * 0.6
      budget -= (capital_budget - buy_capital_ships(capital_budget, squad, planet))
    end

    if current_transports == 0 || current_transports < (current_fighters / 10)
      transport_budget = budget * 0.3
      budget -= (transport_budget - buy_transports(transport_budget, squad, planet))
    end

    fighter_budget = budget * 0.8
    budget -= (fighter_budget - buy_fighters(fighter_budget, squad, planet))

    budget = buy_capital_ships(budget, squad, planet) if budget > 500
    buy_fighters(budget, squad, planet) if budget > 0
    
    GroupFleet.new(planet).group!
  end

  def buy_fighters(budget, squad, planet)
    existing_fighter_types = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'Fighter' }).map(&:unit).uniq
    available_units = Unit.allowed_for(squad.faction.name).where(type: 'Fighter').where("credits <= ?", budget)
    
    if existing_fighter_types.count >= 2 && @smartness >= 3
      available_units = available_units.where(id: existing_fighter_types.map(&:id))
    end
    
    return budget if available_units.empty?

    best_fighter = @smartness >= 4 ? available_units.order(credits: :desc).first : available_units.sample
    quantity = (budget / best_fighter.credits).to_i
    BuildFleet.new(quantity, best_fighter, squad, planet).build! if quantity > 0
    
    budget - (quantity * best_fighter.credits)
  end

  def buy_transports(budget, squad, planet)
    available_units = Unit.allowed_for(squad.faction.name).where(type: 'LightTransport').where("credits <= ?", budget)
    return budget if available_units.empty?

    best_transport = @smartness >= 4 ? available_units.order(credits: :desc).first : available_units.sample
    quantity = (budget / best_transport.credits).to_i
    BuildFleet.new(quantity, best_transport, squad, planet).build! if quantity > 0
    
    budget - (quantity * best_transport.credits)
  end

  def buy_capital_ships(budget, squad, planet)
    available_units = Unit.allowed_for(squad.faction.name).where(type: 'CapitalShip').where("credits <= ?", budget)
    return budget if available_units.empty?
    
    best_ship = available_units.order(credits: :desc).first
    quantity = (budget / best_ship.credits).to_i
    BuildFleet.new(quantity, best_ship, squad, planet).build! if quantity > 0
    
    budget - (quantity * best_ship.credits)
  end

  def embark!(fleet)
    cargo = fleet.carriables
    cargo.each do |c|
      ShipFleet.new(c.quantity, c, fleet).embark!
    end
    GroupFleet.new(fleet.planet).group!
  end

  def build!
    planets = Planet.seen_by(@squad).reject { |p| p.fleets.any? { |f| f.unit.type == 'Facility' } || p.fleets.none? { |f| f.unit.type == 'CapitalShip' } }
    return if planets.nil?
    planet = planets.sample unless planets.empty?
    facilities = Unit.allowed_for(@squad.faction.name).where("type = ? AND credits <= ?", 'Facility', @squad.credits)
    facility = facilities.sample unless facilities.empty?
    BuildFleet.new(1, facility, @squad, planet).build! unless facility.nil? || planet.nil?
  end

  def arm!(fleet)
    return if fleet.armament.present?
    return unless fleet.unit.respond_to?(:armable?) && fleet.unit.armable?

    chance_to_arm = rand(1..6)
    return if chance_to_arm > @smartness

    armaments = Unit.allowed_for(@squad.faction.name).where(type: 'Armament')
    return if armaments.empty?

    armament = @smartness >= 4 ? armaments.order(credits: :desc).first : armaments.sample
    fleet.update(armament: armament)
  end

  def choose_destination(reachable_planets, task_force = nil)
    options = reachable_planets.reject { |p| @targeted_planets.include?(p) }
    options = reachable_planets if options.empty? 

    enemy_planets = options.select { |planet| planet.fleets.any? { |fleet| fleet.squad != @squad } }
    unexplored = options.reject { |p| p.fleets.joins(:unit).where(squad: @squad, units: { type: 'Facility' }).any? }
    
    target = if @aggressiveness < 4
               unexplored.any? ? unexplored.sample : enemy_planets.sample
             elsif @aggressiveness > 4
               if enemy_planets.any?
                 @smartness >= 5 ? enemy_planets.min_by { |p| p.fleets.where.not(squad: @squad).sum(:quantity) } : enemy_planets.sample
               else
                 unexplored.sample
               end
             else
               (enemy_planets + unexplored).sample
             end

    target ||= options.sample
    
    @targeted_planets << target if target
    target
  end

  def planet_in_danger?(planet)
    planet.fleets.any? { |f| f.squad != @squad }
  end
end