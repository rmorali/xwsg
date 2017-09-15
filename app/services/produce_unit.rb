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

  def credits?
    @squad.credits >= @unit.credits
  end

  def produce!
    Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: Round.get_current, carrier: @facility) if self.facility? && !self.in_production? && self.credits?
  end



end
