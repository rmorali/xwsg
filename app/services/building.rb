class Building
  def initialize(quantity, unit, squad, planet, *facility)
    @quantity = quantity
    @unit = unit
    @planet = planet
    @squad = squad
    @facility = nil
    @facility = facility.first if facility.present?
    @round = Round.current
  end

  def build!
    Fleet.create(quantity: @quantity, unit: @unit, squad: @squad, planet: @planet, round: @round, ready_in: @unit.producing_time, carrier: @facility) if valid?
  end

  def valid?
    credits = @quantity * @unit.credits
    metals = @quantity * @unit.metals
    @squad.debit_resources(credits, metals)
  end
end
