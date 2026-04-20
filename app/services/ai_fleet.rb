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
    
    organize_planets!

    # 1. CONSTRUÇÃO DE FACILITIES (Regra de 80%)
    # Agora com threshold menor (30% de reserva) para incentivar a expansão
    if @squad.credits > 1200
      build! if @squad.credits >= (@setup.initial_credits * 0.3)
    end

    facilities = Fleet.joins(:unit).where(squad: @squad, units: { type: 'Facility' })
    credits_for_producing = facilities.any? ? @squad.credits / facilities.count : @squad.credits
    
    facilities.each do |facility|
      produce!(facility, credits_for_producing) unless @round.number == 1
    end

    organize_planets!

    # 2. EMBARQUE (Crucial para a nova regra de movimento das Capital Ships)
    carriers = Fleet.joins(:unit).where(squad: @squad).where.not(units: { type: 'Facility' }).select { |f| f.available_capacity > 10 }
    carriers.each { |carrier| embark!(carrier) }

    organize_planets!
    Fleet.where(squad: @squad).each { |fleet| arm!(fleet) }

    # 3. MOVIMENTAÇÃO
    Planet.joins(:fleets).where(fleets: { squad: @squad }).distinct.each do |planet|
      movable_fleets = Fleet.where(squad: @squad, planet: planet, carrier_id: nil).select(&:movable?)
      next if movable_fleets.empty?

      next unless rand(1..10) <= (@aggressiveness + 5)

      # Definição de guarnição mínima
      if movable_fleets.count >= 3
        guarrison = movable_fleets.min_by(&:quantity)
        traveling_pool = movable_fleets - [guarrison]
      else
        traveling_pool = movable_fleets
      end

      next if traveling_pool.empty?

      reachable_planets = Route.in_range_for(planet).to_a
      next if reachable_planets.empty?

      groups = traveling_pool.each_slice((traveling_pool.size / 2.0).ceil).to_a

      groups.each do |group|
        destination = choose_destination(reachable_planets)
        next unless destination

        group.each do |fleet|
          # REGRA DAS CAPITAL SHIPS (Solo só com Fighter de carga)
          if fleet.unit.type == 'CapitalShip'
            # Verifica se há caças no grupo de viagem
            has_fighter_escort = group.any? { |f| f.unit.type == 'Fighter' }
            
            # Verifica se há caças DENTRO da nave capital (Carga)
            has_fighter_cargo = Fleet.joins(:unit).where(carrier: fleet, units: { type: 'Fighter' }).any?

            # Se não tiver escolta nem carga, a Capital Ship cancela a viagem individual
            next if !has_fighter_escort && !has_fighter_cargo
          end

          MoveFleet.new(fleet, fleet.quantity, destination).order!
        end
      end
    end

    @squad.ready!
  end

  private

  def organize_planets!
    Planet.joins(:fleets).where(fleets: { squad: @squad }).distinct.each do |planet|
      GroupFleet.new(planet).group!
    end
  end

  def build!
    # Busca Facilities que custem até 80% do saldo atual do Squad
    max_budget = @squad.credits * 0.8
    available_units = Unit.allowed_for(@squad.faction.name)
                          .where(type: 'Facility')
                          .where("credits <= ?", max_budget)
    
    facility = @smartness >= 4 ? available_units.order(credits: :desc).first : available_units.sample
    return if facility.nil?

    planet = best_planet_for_facility
    return if planet.nil?

    # O BuildFleet debita de @squad.credits automaticamente
    BuildFleet.new(1, facility, @squad, planet).build!
    GroupFleet.new(planet).group!
  end

  def best_planet_for_facility
    # Planetas seguros (sem inimigos) e sem bases atuais
    candidates = Planet.seen_by(@squad).reject do |p|
      p.fleets.joins(:unit).where(units: { type: 'Facility' }).any? || 
      p.fleets.where.not(squad: @squad).any?
    end

    return nil if candidates.empty?

    # Score baseado em renda e segurança
    candidates.sort_by! do |p|
      score = p.credits
      allied_strength = p.fleets.where(squad: @squad).sum(:quantity)
      score += (allied_strength * 2) 
      score
    end

    candidates.last
  end

  def produce!(facility, available)
    planet = facility.planet
    squad = facility.squad
    
    current_capitals = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'CapitalShip' }).sum(:quantity)
    current_fighters = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'Fighter' }).sum(:quantity)
    current_transports = planet.fleets.joins(:unit).where(squad: squad, units: { type: 'LightTransport' }).sum(:quantity)
    
    budget = available

    # Prioridade 1: Garantir que Capital Ships tenham caças para poderem viajar
    if current_fighters < 2
      fighter_budget = budget * 0.5
      budget -= (fighter_budget - buy_fighters(fighter_budget, squad, planet))
    end

    if current_capitals == 0 && budget >= 600
      capital_budget = budget * 0.6
      budget -= (capital_budget - buy_capital_ships(capital_budget, squad, planet))
    end

    if current_transports == 0 || current_transports < (current_fighters / 10)
      transport_budget = budget * 0.3
      budget -= (transport_budget - buy_transports(transport_budget, squad, planet))
    end

    buy_fighters(budget, squad, planet) if budget > 0
  end

  def buy_fighters(budget, squad, planet)
    available_units = Unit.allowed_for(squad.faction.name).where(type: 'Fighter').where("credits <= ?", budget)
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
  end

  def build!
    max_budget = @squad.credits * 0.8
    available_units = Unit.allowed_for(@squad.faction.name).where(type: 'Facility').where("credits <= ?", max_budget)
    return if available_units.empty?

    facility = @smartness >= 4 ? available_units.order(credits: :desc).first : available_units.sample
    planet = best_planet_for_facility
    return if planet.nil? || facility.nil?

    BuildFleet.new(1, facility, @squad, planet).build!
    GroupFleet.new(planet).group!
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

  def choose_destination(reachable_planets)
    options = reachable_planets.reject { |p| @targeted_planets.include?(p) }
    options = reachable_planets if options.empty? 
    enemy_planets = options.select { |planet| planet.fleets.any? { |fleet| fleet.squad != @squad } }
    unexplored = options.reject { |p| p.fleets.any? { |f| f.squad == @squad } }
    
    target = if @aggressiveness < 4
               unexplored.any? ? unexplored.sample : enemy_planets.sample
             elsif @aggressiveness > 4
               if enemy_planets.any? && unexplored.any? && rand(1..10) <= 3
                 unexplored.sample
               elsif enemy_planets.any?
                 @smartness >= 5 ? enemy_planets.min_by { |p| p.fleets.where.not(squad: @squad).sum(:quantity) } : enemy_planets.sample
               else
                 unexplored.sample
               end
             else
               if enemy_planets.any? && unexplored.any?
                  rand(1..10) <= 7 ? unexplored.sample : enemy_planets.sample
               else
                  (enemy_planets + unexplored).sample
               end
             end

    target ||= options.sample
    @targeted_planets << target if target
    target
  end

  def planet_in_danger?(planet)
    planet.fleets.any? { |f| f.squad != @squad }
  end
end