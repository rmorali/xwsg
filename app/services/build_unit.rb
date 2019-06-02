class BuildUnit
  def initialize(unit, squad, planet)
    @unit = unit
    @squad = squad
    @planet = planet
  end

  def build!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.current, ready_in: @unit.producing_time) if valid?
  end
  
  def valid?
    @squad.debit_resources(@unit)
  end

  
end
