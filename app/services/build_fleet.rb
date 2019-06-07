class BuildFleet
  def initialize(quantity, unit, squad, planet, facility = nil)
    @quantity = quantity
    @unit = unit
    @planet = planet
    @squad = squad
    @facility = facility unless facility.nil?
    @round = Round.current
  end

  def build!
    @quantity.times do
      Fleet.create(quantity: 1, unit: @unit, squad: @squad, planet: @planet, round: @round, ready_in: @unit.producing_time, carrier: @facility) if valid?
    end
    #GroupFleet.new(@planet).group!
  end

  def valid?
    credits = @quantity * @unit.credits
    metals = @quantity * @unit.metals.to_i
    @squad.debit_resources(credits, metals)
  end

end
