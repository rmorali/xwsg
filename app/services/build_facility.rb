class BuildFacility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def valid?
    @squad.debit_resources(@facility)
  end

  def build!
    Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.current, ready_in: @facility.producing_time) if valid?
  end
end
