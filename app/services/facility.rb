class Facility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def build!
    facility = Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.getCurrent)
  end

end
