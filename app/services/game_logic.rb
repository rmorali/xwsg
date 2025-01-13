class GameLogic
  def initialize
    @squads = Squad.all
    @round = Round.current
    @setup = Setup.current
  end

  def new_game!
    Planet.all.each { |p| p.update(credits: rand(20..100)) }
    SetWormhole.new.create!
    #faction = Faction.all.reject { |faction| faction == Squad.last.faction }
    #faction = faction[rand(faction.count)]
    #Squad.first.update(faction: faction)
    Squad.all.each do |squad|
      set_initial(squad)
      warp_fleets_for(squad)
      AiFleet.new(squad).act!
    end
    Planet.all.each do |planet|
      GroupFleet.new(planet).group!
    end

  end

  def check_state!
    if @squads.all?(&:ready?) == true
      @round.next_phase!
      @squads.update_all(ready: nil)
      check_phase!
    end
  end

  def check_phase!
    strategy! if @round.strategy?
    space_combat! if @round.space_combat?
    finished! if @round.finished?
  end

  def strategy!; end

  def space_combat!
    UpdateFleet.new.move!
    CreateResult.new.create!
    ai_squads = Squad.where(ai: true)
    ai_squads.each do |squad|
      squad.update(ready: true)
    end
  end

  def ground_combat!; end

  def finished!;
    results = Result.where(round: @round)
    results.each do |result|
      ApplyResult.new(result).apply!
    end
    Squad.all.each do |squad|
      squad.credits += SetIncome.new(squad, Planet.first).total
      squad.save
    end
    UpdateFleet.new.build!
    ai_squads = Squad.where(ai: true)
    ai_squads.each do |squad|
      AiFleet.new(squad).act!
    end
    Fleet.where('ready_in < ?', 0).update_all(ready_in: 0)
  end

  def warp_fleets_for(squad)
    planets_quantity = @setup.initial_planets
    available = squad.credits / planets_quantity
    planets_quantity.times do
      for_facilities = available * 0.40
      for_capital_ships = available * 0.20
      for_fighters = available * 0.40
      planet = Planet.random
      # Facilities
      facilities = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Facility', for_facilities)
      facility = facilities[rand(facilities.count)] unless facilities.empty?
      BuildFleet.new(1, facility, squad, planet).build! unless facility.nil?
      # Capital Ships 
      until for_capital_ships < 300 do
        capital_ships = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'CapitalShip', for_capital_ships)
        capital_ship = capital_ships[rand(capital_ships.count)] unless capital_ships.empty?
        unless capital_ship.nil?
          BuildFleet.new(1, capital_ship, squad, planet).build!
          for_capital_ships -= capital_ship.credits
        else
          break
        end
      end
      # Fighters
      for_fighters = for_fighters / 2
      2.times do
        fighters = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Fighter', for_fighters)
        fighter = fighters[rand(fighters.count)]
        BuildFleet.new( (for_fighters / fighter.credits).to_i, fighter, squad, planet).build! unless fighter.nil?
      end
      GroupFleet.new(planet).group!
    end
  end

  def set_initial(squad)
    squad.update(credits: @setup.initial_credits)
  end

end
