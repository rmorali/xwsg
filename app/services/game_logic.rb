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

  end

  def ground_combat!

  end

  def finished!

  end
end
