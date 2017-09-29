class GameLogic
  def initialize
    @squads = Squad.all
    @round = Round.current
  end

  def check_state!
    if @squads.all? { |squad| squad.ready? } == true
      @round.next_phase!
      @squads.update_all(ready: nil)
      check_phase!
    end
  end

  def check_phase!
    strategy! if @round.phase == 0
    space_combat! if @round.phase == 1
    ground_combat! if @round.phase == 2
    finished! if @round.phase == 3
  end

  def strategy!

  end

  def space_combat!
    moving_fleets = Fleet.where.not(destination: nil)
    moving_fleets.each { |fleet| fleet.update(arrives_in: fleet.arrives_in -= 1) }
    arriving_fleets = Fleet.where(arrives_in: 0)
    arriving_fleets.each { |fleet| fleet.update(planet: fleet.destination, destination: nil, arrives_in: nil) }
  end

  def ground_combat!

  end

  def finished!

  end
end
