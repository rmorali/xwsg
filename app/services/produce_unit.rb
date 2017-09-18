class ProduceUnit
  def initialize(facility, unit)
    @facility = facility
    @unit = unit
    @squad = facility.squad
    @planet = facility.planet
  end

  def facility?
    @facility.unit.type == 'Facility'
  end

  def in_production?
    @facility.in_production?
  end

  def metals?
    @squad.debit(@unit.metals, 'metals')
  end

  def ready_in
    Round.get_current.number + @unit.producing_time
  end

  def produce!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.get_current, ready_in: ready_in, carrier: @facility) if facility? && !in_production? && metals?
  end
end
