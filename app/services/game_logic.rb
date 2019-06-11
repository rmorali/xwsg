class GameLogic
  def initialize
    @squads = Squad.all
    @round = Round.current
    @setup = Setup.current
  end

  def new_game!
    Planet.update_all(credits: 100)
    SetWormhole.new.create!
    Squad.all.each do |squad|
      set_initial(squad)
      warp_fleets_for(squad)
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
  end

  def ground_combat!; end

  def finished!;
    results = Result.where(round: @round)
    results.each do |result|
      ApplyResult.new(result).apply!
    end
    UpdateFleet.new.build!
  end

  def warp_fleets_for(squad)
    planets_quantity = @setup.initial_planets
    available_credits = squad.credits / planets_quantity
    planets_quantity.times do
      planet = Planet.random
      facilities = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Facility', 1200)
      capital_ships = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'CapitalShip', 1200)
      fighters = Unit.allowed_for(squad.faction.name).where("type = ? AND credits <= ?", 'Fighter', 100)
      facility = facilities[rand(facilities.count)]
      capital_ship = capital_ships[rand(capital_ships.count)]
      fighter = fighters[rand(fighters.count)]
      BuildFleet.new(1, facility, squad, planet).build! unless facility.nil?
      BuildFleet.new( (1200 / capital_ship.credits), capital_ship, squad, planet).build! unless capital_ship.nil?
      BuildFleet.new( ((available_credits - 2400) / fighter.credits), fighter, squad, planet).build! unless fighter.nil?
    end
  end

  def set_initial(squad)
    squad.update(credits: @setup.initial_credits)
  end

end
