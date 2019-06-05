class ApplyResult
  def initialize(result)
    @result = result
    @fleet = @result.fleet
  end

  def blast!
    @fleet.update(quantity: @fleet.quantity - @result.blasted)
    @result.update(final_quantity: @fleet.quantity - @result.blasted)
  end

  def flee!
    random_planet = Route.in_range_for(@fleet)[rand(Route.in_range_for(@fleet).count)]
    fleeing_fleet = @fleet.dup
    fleeing_fleet.update(quantity: @result.fled, planet: random_planet)
    @fleet.update(quantity: @fleet.quantity - @result.fled)
    @result.update(final_quantity: @fleet.quantity - @result.fled)
  end

  def capture!
    captured_fleet = @fleet.dup
    captured_fleet.update(quantity: @result.captured, squad: @result.captor)
    @fleet.update(quantity: @fleet.quantity - @result.captured)
    @result.update(final_quantity: @fleet.quantity - @result.captured)
  end
end