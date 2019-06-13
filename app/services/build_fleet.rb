class BuildFleet
  def initialize(quantity, unit, squad, planet, facility = nil)
    @quantity = quantity
    @unit = unit
    @planet = planet
    @squad = squad
    @facility = nil
    if unit.producing_time > 0
      @facility = facility unless facility.nil?
    end
    @round = Round.current
  end

  def build!
    @quantity.times do
      Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: @round, ready_in: @unit.producing_time,
        carrier: @facility, level: 0, ai: @squad.ai) if valid?
    end
  end

  def valid?
    credits = @unit.credits
    @squad.debit_resources(credits)
  end

end
