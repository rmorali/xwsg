class Facility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def build!
    Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.get_current) if self.facility? && self.credits? && self.faction?
  end

  def facility?
    @facility.type == 'Facility'
  end

  def credits?
    @squad.credits >= @facility.credits
  end

  def faction?
    @facility.belongs?(@squad.faction)
  end

end
