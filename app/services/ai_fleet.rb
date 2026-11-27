class AiFleet
  FIGHTER_TYPES   = %w[Fighter Interceptor Bomber].freeze
  TRANSPORT_TYPES = %w[LightTransport HeavyTransport].freeze
  GROUND_TYPES    = %w[Infantry Armor Artillery Cavalry Warrior].freeze
  CRITICAL_ASSETS = %w[Facility CapitalShip].freeze
  PT_ARMED_TYPES  = %w[Bomber LightTransport].freeze

  # Proporção alvo ideal da frota espacial do esquadrão
  TARGET_RATIOS = {
    'Fighter'        => 0.40,
    'Interceptor'    => 0.20,
    'Bomber'         => 0.15,
    'LightTransport' => 0.15,
    'CapitalShip'    => 0.10
  }.freeze

  def initialize(squad = nil)
    @squad = squad
    @setup = Setup.current
    @round = Round.current
    @smartness = (@squad&.ai_level || 3).clamp(1, 6)
    @aggressiveness = (@squad&.ai_level || 3).clamp(1, 6)
    @targeted_planets = []
  end

  def act!
    return unless @squad&.ai == true

    organize_planets!

    # 1. PRIORIDADE MÁXIMA: PRODUÇÃO ONDE HOUVER FACILITY CONSTRUÍDA (ready_in: 0 ou nil)
    ready_facilities = squad_fleets.select { |f| f.type == 'Facility' && !f.in_production? }

    if ready_facilities.any?
      ordered_facilities = ready_facilities.sort_by do |fac|
        intel = neighbor_intel(fac.planet)
        -(intel[:enemy_power] + intel[:neutral_credits])
      end

      arm_reserve = @smartness >= 3 ? (@squad.credits * 0.10).floor : 0
      usable_credits = [@squad.credits - arm_reserve, 0].max
      budget_per_facility = usable_credits / ordered_facilities.count

      ordered_facilities.each do |facility|
        produce_at!(facility, budget_per_facility)
      end
    end

    organize_planets!

    # 2. EXPANSÃO ECONÔMICA: CONSTRUIR NOVA FACILITY COM SALDO EXCEDENTE (MÁX. 1 POR PLANETA)
    expansion_threshold = [(@setup&.initial_credits.to_i * 0.45), 1800].max
    if @squad.credits >= expansion_threshold
      build_facility!
    end

    organize_planets!

    # 3. EMBARQUE LOGÍSTICO (Respeitando guarnição de Facilities prontas ou em construção)
    allied_planets.each do |planet|
      embark_planet_forces!(planet)
    end

    organize_planets!

    # 4. EQUIPAR OGIVAS / ARMAMENTOS
    squad_fleets.each { |fleet| arm!(fleet) }

    # 5. FORMAÇÃO DE TASK FORCES E MOVIMENTAÇÃO TÁTICA
    allied_planets.each do |planet|
      dispatch_task_forces!(planet)
    end

    @squad.ready!
  end

  private

  def squad_fleets
    Fleet.includes(:unit, :planet, :destination, :carrier).where(squad: @squad).to_a
  end

  def allied_planets
    Planet.joins(:fleets).where(fleets: { squad: @squad }).distinct.to_a
  end

  def organize_planets!
    allied_planets.each do |planet|
      GroupFleet.new(planet).group!
    end
  end

  # ==========================================================================
  # 1. PRODUÇÃO PROPORCIONAL NOS ESTALEIROS (FACILITIES)
  # ==========================================================================
  def produce_at!(facility, available_budget)
    planet = facility.planet
    budget = available_budget.to_i
    return if budget <= 0

    local_fleets      = Fleet.includes(:unit).where(squad: @squad, planet: planet).to_a
    local_capitals    = local_fleets.select { |f| f.type == 'CapitalShip' }.sum(&:quantity)
    local_fighters    = local_fleets.select { |f| FIGHTER_TYPES.include?(f.type) }.sum(&:quantity)
    local_transports  = local_fleets.select { |f| TRANSPORT_TYPES.include?(f.type) }.sum(&:quantity)
    unloaded_fighters = local_fleets.select { |f| f.carrier_id.nil? && (f.type == 'Fighter' || f.hyperdrive.to_i < 1) }.sum(&:quantity)

    intel = @smartness >= 5 ? neighbor_intel(planet) : {}

    # Passo A: Garante ao menos 2 Fighters locais para escolta de CapitalShip e defesa da Facility
    if local_fighters < 2
      budget = buy_unit_type(budget, planet, facility, 'Fighter', max_qty: 2 - local_fighters, intel: intel)
    end

    # Passo B: Se há Fighters/naves sem hiperdrive precisando de transporte para expandir, garante LightTransport
    if unloaded_fighters >= 2 && local_transports.zero? && budget >= 200
      budget = buy_unit_type(budget, planet, facility, 'LightTransport', max_qty: 1, intel: intel)
    end

    # Passo C: Produz seguindo o déficit da proporção alvo
    4.times do
      break if budget <= 0

      ranked_types = ranked_unit_types_by_deficit(local_capitals, intel)
      purchased_in_cycle = false

      ranked_types.each do |unit_type|
        next if unit_type == 'CapitalShip' && local_capitals >= 1

        max_batch = unit_type == 'CapitalShip' ? 1 : (@smartness >= 5 ? 3 : 4)
        new_budget = buy_unit_type(budget, planet, facility, unit_type, max_qty: max_batch, intel: intel)

        if new_budget < budget
          budget = new_budget
          local_capitals += 1 if unit_type == 'CapitalShip'
          purchased_in_cycle = true
          break
        end
      end

      break unless purchased_in_cycle
    end
  end

  def ranked_unit_types_by_deficit(local_capitals, intel)
    all_units = squad_fleets.reject { |f| f.type == 'Facility' }
    total_qty = all_units.sum(&:quantity).to_f

    adjusted_ratios = TARGET_RATIOS.dup
    if @smartness >= 5 && intel.present?
      if intel[:enemy_capitals].to_i > 0
        adjusted_ratios['Bomber']         += 0.12
        adjusted_ratios['Fighter']        -= 0.07
        adjusted_ratios['LightTransport'] -= 0.05
      end
      if intel[:enemy_fighters].to_i > 3
        adjusted_ratios['Interceptor']    += 0.10
        adjusted_ratios['CapitalShip']    -= 0.05
        adjusted_ratios['LightTransport'] -= 0.05
      end
    end

    if total_qty < 4
      return %w[Fighter LightTransport Interceptor Bomber CapitalShip]
    end

    adjusted_ratios.keys.sort_by do |type|
      next 999 if type == 'CapitalShip' && local_capitals >= 1

      current_qty   = all_units.select { |f| f.type == type }.sum(&:quantity)
      current_ratio = current_qty / total_qty
      -(adjusted_ratios[type] - current_ratio)
    end
  end

  def buy_unit_type(budget, planet, facility, unit_type, max_qty: 3, intel: {})
    max_distinct_models = @smartness >= 5 ? 2 : 3
    existing_unit_ids   = squad_fleets.select { |f| f.type == unit_type }.map(&:unit_id).uniq

    scope = Unit.allowed_for(@squad.faction.name)
                .where(type: unit_type)
                .where('credits <= ?', budget)

    if existing_unit_ids.size >= max_distinct_models
      constrained = scope.where(id: existing_unit_ids)
      scope = constrained if constrained.exists?
    end

    return budget if scope.empty?

    chosen = select_best_unit(scope, intel)
    return budget if chosen.nil? || chosen.credits.to_i <= 0

    affordable_qty = (budget / chosen.credits).to_i
    qty = [affordable_qty, max_qty].min
    return budget if qty <= 0

    BuildFleet.new(qty, chosen, @squad, planet, facility).build!
    budget - (qty * chosen.credits)
  end

  def select_best_unit(scope, intel)
    return scope.sample if @smartness <= 2

    if @smartness >= 5 && intel.present?
      return scope.max_by do |u|
        score = u.credits.to_f
        score += u.ordnance_attack.to_i * 12 if intel[:enemy_capitals].to_i > 0
        score += u.laser_attack.to_i * 10    if intel[:enemy_fighters].to_i > 0
        score += u.capacity.to_i * 5
        score += u.hyperdrive.to_i * 35
        score
      end
    end

    scope.order(credits: :desc).first
  end

  # ==========================================================================
  # 2. EXPANSÃO ECONÔMICA (MÁX. 1 FACILITY POR PLANETA)
  # ==========================================================================
  def build_facility!
    max_budget = @squad.credits * 0.75
    available_facilities = Unit.allowed_for(@squad.faction.name)
                               .where(type: 'Facility')
                               .where('credits <= ?', max_budget)
    return if available_facilities.empty?

    facility_unit = @smartness >= 4 ? available_facilities.order(credits: :desc).first : available_facilities.sample
    planet = best_planet_for_facility
    return if facility_unit.nil? || planet.nil?

    BuildFleet.new(1, facility_unit, @squad, planet).build!
    GroupFleet.new(planet).group!
  end

  def best_planet_for_facility
    candidates = Planet.seen_by(@squad).reject do |p|
      has_any_facility = Fleet.joins(:unit).where(planet: p, units: { type: 'Facility' }).exists?
      has_enemies      = Fleet.where(planet: p).where.not(squad: @squad).exists?
      next true if has_any_facility || has_enemies

      # Exige presença aliada no planeta para não construir base desguarnecida
      has_allied_presence = Fleet.where(planet: p, squad: @squad).exists?
      next true unless has_allied_presence

      if @smartness >= 5
        local_power = combat_power(Fleet.includes(:unit).where(planet: p, squad: @squad))
        neighbor_intel(p)[:enemy_power] > (local_power * 1.25)
      else
        false
      end
    end

    return nil if candidates.empty?

    candidates.max_by do |p|
      local_power = combat_power(Fleet.includes(:unit).where(planet: p, squad: @squad))
      p.credits.to_i + (local_power * 0.4)
    end
  end

  # ==========================================================================
  # 3. EMBARQUE LOGÍSTICO
  # ==========================================================================
  def embark_planet_forces!(planet)
    has_building_facility = has_constructing_facility?(planet)
    garrison, keep_qty = garrison_allocation(planet)

    carriers = Fleet.includes(:unit).where(squad: @squad, planet: planet, carrier_id: nil, destination_id: nil)
                    .reject { |f| f.type == 'Facility' || f.in_production? }
                    .select { |f| f.available_capacity > 0 }
                    .sort_by { |f| TRANSPORT_TYPES.include?(f.type) ? 0 : 1 }

    return if carriers.empty?

    local_stationary = Fleet.includes(:unit).where(squad: @squad, planet: planet, carrier_id: nil, destination_id: nil)
                            .reject { |f| f.in_production? || !f.carriable }

    # 1º: Naves sem hiperdrive
    no_hd = local_stationary.select { |f| f.hyperdrive.to_i < 1 }
    load_cargo_into_carriers(no_hd, carriers, garrison, keep_qty, has_building_facility)

    # 2º: Fighters (para poderem viajar a planetas neutros/inimigos)
    fighters = local_stationary.select { |f| f.type == 'Fighter' && f.hyperdrive.to_i >= 1 }
    load_cargo_into_carriers(fighters, carriers, garrison, keep_qty, has_building_facility)

    # 3º: Interceptors, Bombers e Tropas Terrestres
    others = local_stationary.select { |f| (%w[Interceptor Bomber] + GROUND_TYPES).include?(f.type) }
    load_cargo_into_carriers(others, carriers, garrison, keep_qty, has_building_facility)
  end

  def load_cargo_into_carriers(cargo_list, carriers, garrison, keep_qty, has_building_facility)
    cargo_list.each do |cargo|
      cargo.reload
      reserved = if has_building_facility && garrison && cargo.id == garrison.id
                   cargo.quantity.to_i
                 elsif garrison && cargo.id == garrison.id
                   keep_qty
                 else
                   0
                 end

      available_to_load = cargo.quantity.to_i - reserved
      next if available_to_load <= 0

      unit_weight = cargo.unit.weight.to_i
      next if unit_weight <= 0

      carriers.each do |carrier|
        carrier.reload
        avail = carrier.available_capacity
        next if avail < unit_weight

        qty_to_load = [available_to_load, (avail / unit_weight).to_i].min
        next if qty_to_load <= 0

        ShipFleet.new(qty_to_load, cargo, carrier).embark!
        available_to_load -= qty_to_load
        break if available_to_load <= 0
      end
    end
  end

  # ==========================================================================
  # 4. ARMAMENTO / OGIVAS (Seletivo; Bombers e LightTransports apenas PT/PT+Chf)
  # ==========================================================================
  def arm!(fleet)
    return unless fleet.armable?
    return if fleet.in_production?

    arm_chance = case @smartness
                 when 1..2 then 15
                 when 3..4 then 30
                 else 45
                 end
    return if rand(1..100) > arm_chance

    armaments = Unit.allowed_for(@squad.faction.name)
                    .where(type: 'Armament')
                    .where('credits <= ?', @squad.credits)
                    .to_a
    return if armaments.empty?

    pool = if PT_ARMED_TYPES.include?(fleet.type)
             # Bombers e LightTransports recebem OBRIGATORIAMENTE PT ou PT+Chf (nunca CM)
             armaments.select { |a| pt_armament?(a) }
           else
             # Demais classes armáveis recebem apenas CM ou CM+Chf
             armaments.select { |a| cm_armament?(a) }
           end

    return if pool.empty?

    armament = @smartness >= 4 ? pool.max_by { |a| a.credits.to_i } : pool.sample
    return unless armament

    if @squad.debit_credits(armament.credits)
      fleet.update(armament: armament)
    end
  end

  def pt_armament?(unit)
    label = "#{unit.name} #{unit.try(:acronym)}".upcase
    label.include?('PT') || label.include?('PROTON')
  end

  def cm_armament?(unit)
    label = "#{unit.name} #{unit.try(:acronym)}".upcase
    (label.include?('CM') || label.include?('CONCUSSION')) && !pt_armament?(unit)
  end

  # ==========================================================================
  # 5. FORMAÇÃO DE TASK FORCES E MOVIMENTAÇÃO TÁTICA
  # ==========================================================================
  def dispatch_task_forces!(planet)
    movable_fleets = Fleet.includes(:unit).where(squad: @squad, planet: planet, carrier_id: nil, destination_id: nil)
                          .select(&:movable?)
    return if movable_fleets.empty?

    neighbors = Route.in_range_for(planet).to_a
    return if neighbors.empty?

    intel = @smartness >= 5 ? neighbor_intel(planet) : { enemy_power: 0, threats_by_planet: {} }
    total_local_power = combat_power(movable_fleets)

    if @smartness >= 5 && intel[:enemy_power] > 0 && total_local_power < (intel[:enemy_power] * 0.9)
      return
    end

    move_roll = rand(1..10)
    return unless move_roll <= (@aggressiveness + 5)

    has_building_facility = has_constructing_facility?(planet)
    garrison, keep_qty = garrison_allocation(planet)

    # Nunca abandona uma Facility em construção se houver apenas 1 frota móvel de guarda
    if has_building_facility && garrison && movable_fleets.size == 1 && movable_fleets.first.id == garrison.id
      return
    end

    traveling_orders = []
    movable_fleets.each do |f|
      if garrison && f.id == garrison.id && f.cargo.empty?
        retained = has_building_facility ? [(f.quantity.to_i / 2.0).ceil, keep_qty].max : keep_qty
        send_qty = f.quantity.to_i - retained
        traveling_orders << { fleet: f, qty: send_qty } if send_qty > 0
      else
        traveling_orders << { fleet: f, qty: f.quantity.to_i }
      end
    end

    if garrison.nil? && traveling_orders.size >= 2
      smallest = traveling_orders.min_by { |o| combat_power([o[:fleet]]) }
      traveling_orders.delete(smallest) if smallest[:fleet].cargo.empty?
    end

    return if traveling_orders.empty?

    task_forces = build_cohesive_task_forces(traveling_orders)

    task_forces.each do |tf|
      tf_power = tf.sum { |o| combat_power([o[:fleet]]) }
      destination = choose_destination_for_tf(tf, neighbors, tf_power, intel)
      next unless destination

      tf.each do |order|
        allowed_for_fleet = Route.in_range_for(order[:fleet]).to_a
        next unless allowed_for_fleet.include?(destination)

        MoveFleet.new(order[:fleet], order[:qty], destination).order!
      end
    end
  end

  def build_cohesive_task_forces(orders)
    capitals   = orders.select { |o| o[:fleet].type == 'CapitalShip' }
    transports = orders.select { |o| TRANSPORT_TYPES.include?(o[:fleet].type) }
    fighters   = orders.select { |o| FIGHTER_TYPES.include?(o[:fleet].type) }
    others     = orders - capitals - transports - fighters

    forces = []

    capitals.each do |cap_order|
      cap = cap_order[:fleet]
      has_fighter_cargo = cap.cargo.any? { |c| FIGHTER_TYPES.include?(c.type) }
      escort = fighters.shift

      next if !has_fighter_cargo && escort.nil?

      group = [cap_order]
      group << escort if escort
      group << transports.shift if transports.any?
      forces << group
    end

    transports.each do |tr_order|
      group = [tr_order]
      group << fighters.shift if fighters.any?
      forces << group
    end

    (fighters + others).each_slice(2) do |slice|
      forces << slice
    end

    forces
  end

  def choose_destination_for_tf(tf, neighbors, tf_power, intel)
    leader = tf.first[:fleet]
    valid_neighbors = Route.in_range_for(leader).to_a
    return nil if valid_neighbors.empty?

    options = valid_neighbors.reject { |p| @targeted_planets.include?(p) }
    options = valid_neighbors if options.empty?

    enemy_planets       = options.select { |p| Fleet.where(planet: p).where.not(squad: @squad).exists? }
    neutral_planets     = options.reject { |p| Fleet.where(planet: p).exists? }
    allied_planets_opts = options - enemy_planets - neutral_planets

    threats_map = intel[:threats_by_planet] || {}

    viable_enemies = if @smartness >= 5
                       enemy_planets.select do |p|
                         threat = threats_map[p.id] || combat_power(Fleet.includes(:unit).where(planet: p).where.not(squad: @squad))
                         tf_power >= (threat * 1.15)
                       end
                     else
                       enemy_planets
                     end

    target = if @smartness >= 5
               if viable_enemies.any?
                 viable_enemies.max_by { |p| p.credits.to_i }
               elsif neutral_planets.any?
                 neutral_planets.max_by { |p| p.credits.to_i }
               elsif allied_planets_opts.any?
                 allied_planets_opts.max_by { |p| neighbor_intel(p)[:enemy_power] }
               end
             elsif @aggressiveness >= 4
               if neutral_planets.any? && viable_enemies.any?
                 rand(1..10) <= 6 ? neutral_planets.max_by { |p| p.credits.to_i } : viable_enemies.min_by { |p| combat_power(Fleet.includes(:unit).where(planet: p).where.not(squad: @squad)) }
               elsif neutral_planets.any?
                 neutral_planets.max_by { |p| p.credits.to_i }
               elsif viable_enemies.any?
                 viable_enemies.sample
               else
                 allied_planets_opts.sample
               end
             else
               neutral_planets.any? ? neutral_planets.sample : (viable_enemies + allied_planets_opts).sample
             end

    target ||= (neutral_planets + viable_enemies + allied_planets_opts).sample
    @targeted_planets << target if target
    target
  end

  # ==========================================================================
  # GUARNIÇÃO & RECONHECIMENTO DE VIZINHOS
  # ==========================================================================
  def has_critical_asset?(planet)
    Fleet.joins(:unit).where(squad: @squad, planet: planet, units: { type: CRITICAL_ASSETS }).exists?
  end

  def has_constructing_facility?(planet)
    Fleet.joins(:unit)
         .where(squad: @squad, planet: planet, units: { type: 'Facility' })
         .where('ready_in > 0')
         .exists?
  end

  def garrison_allocation(planet)
    return [nil, 0] unless has_critical_asset?(planet)

    candidates = Fleet.includes(:unit)
                      .where(squad: @squad, planet: planet, carrier_id: nil, destination_id: nil)
                      .reject { |f| CRITICAL_ASSETS.include?(f.type) || f.cargo.any? }

    return [nil, 0] if candidates.empty?

    fighters = candidates.select { |f| FIGHTER_TYPES.include?(f.type) }
    pool = fighters.any? ? fighters : candidates
    chosen = pool.min_by { |f| combat_power([f]) }

    other_escorts = candidates.reject { |f| f.id == chosen.id }
    keep_qty = if has_constructing_facility?(planet)
                 other_escorts.any? ? chosen.quantity : [2, chosen.quantity].min
               else
                 other_escorts.any? ? chosen.quantity : [1, chosen.quantity].min
               end

    [chosen, keep_qty]
  end

  def neighbor_intel(planet)
    neighbors = Route.in_range_for(planet).to_a
    threats_by_planet = {}
    total_enemy_power = 0
    enemy_capitals = 0
    enemy_fighters = 0
    neutral_credits = 0

    neighbors.each do |n|
      enemies_here     = Fleet.includes(:unit).where(planet: n).where.not(squad: @squad).to_a
      enemies_incoming = Fleet.includes(:unit).where(destination_id: n.id).where.not(squad: @squad).to_a
      combined = (enemies_here + enemies_incoming).uniq

      if combined.any?
        pwr = combat_power(combined)
        threats_by_planet[n.id] = pwr
        total_enemy_power += pwr
        enemy_capitals += combined.count { |f| f.type == 'CapitalShip' }
        enemy_fighters += combined.sum { |f| FIGHTER_TYPES.include?(f.type) ? f.quantity.to_i : 0 }
      elsif !Fleet.where(planet: n).exists?
        neutral_credits += n.credits.to_i
      end
    end

    {
      enemy_power: total_enemy_power,
      enemy_capitals: enemy_capitals,
      enemy_fighters: enemy_fighters,
      neutral_credits: neutral_credits,
      threats_by_planet: threats_by_planet
    }
  end

  def combat_power(fleets)
    fleets.sum do |f|
      u = f.unit
      next 0 if u.type == 'Facility'

      cargo_power = f.cargo.any? ? combat_power(f.cargo) : 0
      unit_score = u.shield.to_i +
                   u.hull.to_i +
                   (u.laser_attack.to_i * 6) +
                   (u.ion_attack.to_i * 5) +
                   (u.ordnance_attack.to_i * 7) +
                   u.credits.to_i

      (unit_score * f.quantity.to_i) + cargo_power
    end
  end
end