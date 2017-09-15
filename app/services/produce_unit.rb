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

  def produce!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.get_current, carrier: @facility) if self.facility? && !self.in_production? && self.metals?
  end



end
