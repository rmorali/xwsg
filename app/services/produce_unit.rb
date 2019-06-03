class ProduceUnit
  def initialize(quantity, unit, squad, planet, *facility)
    @quantity = quantity
    @unit = unit
    @squad = squad
    @planet = planet
    @facility = facility
    @round = Round.current
  end

  def valid?
    credits = @quantity * @unit.credits
    metals = @quantity * @unit.metals
    @squad.debit_resources(credits, metals)
  end

  def produce!
    Fleet.create(quantity: @quantity, unit: @unit, squad: @squad, planet: @planet, round: @round, ready_in: @unit.producing_time, carrier: @facility) if valid?
  end
end
