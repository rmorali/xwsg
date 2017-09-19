class ProduceUnit
  def initialize(facility, unit)
    @facility = facility
    @unit = unit
    @squad = facility.squad
    @planet = facility.planet
  end

  def valid?
    @facility.facility? && !in_production? && metals?
  end

  def in_production?
    @facility.in_production?
  end

  def metals?
    @squad.debit_metals(@unit.metals)
  end

  def ready_in
    Round.current.number + @unit.producing_time
  end

  def produce!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.current, ready_in: ready_in, carrier: @facility) if valid?
  end
end
