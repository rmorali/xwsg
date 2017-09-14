class Facility
  def initialize(facility, squad, planet)
    @facility = facility
    @squad = squad
    @planet = planet
  end

  def build!
    Fleet.create(quantity: 1, unit: @facility, squad: @squad, planet: @planet, round: Round.get_current) if self.able_to_construct?
  end

  def able_to_construct?
    if @facility.type == 'Facility' && @squad.credits >= @facility.credits && @facility.belongs?(@squad.faction)
      return true
    end
  end

end
