class BuildFacility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def valid?
    @facility.facility? && credits?
  end

  def credits?
    @squad.debit_credits(@facility.credits)
  end

  def ready_in
    Round.current.number + @facility.producing_time
  end

  def build!
    Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.current, ready_in: ready_in) if valid?
  end
end
