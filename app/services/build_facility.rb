class BuildFacility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def facility?
    @facility.type == 'Facility'
  end

  def credits?
    @squad.debit(@facility.credits, 'credits')
  end

  def ready_in
    Round.get_current.number + @facility.producing_time
  end

  def build!
    Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.get_current, ready_in: self.ready_in) if self.facility? && self.credits?
  end

end
