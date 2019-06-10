class ApplyResult
  def initialize(result)
    @result = result
    @fleet = @result.fleet
  end

  def apply!
    blast! if @result.blasted.to_i > 0
    flee! if @result.fled.to_i > 0
    capture! if @result.captured.to_i > 0 && @result.captor
  end

  def blast!
    @result.update(final_quantity: @fleet.quantity - @result.blasted)
    @fleet.update(quantity: @fleet.quantity - @result.blasted)
  end

  def flee!
    @result.update(final_quantity: @fleet.quantity - @result.fled)
    random_planet = Route.in_range_for(@fleet)[rand(Route.in_range_for(@fleet).count)]
    fleeing_fleet = @fleet.dup
    fleeing_fleet.update(quantity: @result.fled, planet: random_planet)
    @fleet.update(quantity: @fleet.quantity - @result.fled)
  end

  def capture!
    #@result.update(final_quantity: @fleet.quantity - @result.captured)
    captured_fleet = @fleet.dup
    captured_fleet.update(quantity: @result.captured, squad: @result.captor)
    @fleet.update(quantity: @fleet.quantity - @result.captured)
  end
end
