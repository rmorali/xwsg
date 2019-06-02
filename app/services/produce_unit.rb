class ProduceUnit
  def initialize(unit, squad, planet, *facility)
    @facility = facility
    @unit = unit
    @squad = facility.squad
    @planet = facility.planet
    #TODO quantidades
  end

  def valid?
    @squad.debit_resources(@unit)
  end

  def produce!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.current, ready_in: @unit.producing_time, carrier: @facility) if valid?
  end
end
