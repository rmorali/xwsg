class ApplyResult
  def initialize(result)
    @result = result
    @fleet = @result.fleet
  end

  def apply!
    @result.update(final_quantity: @result.quantity)
    blast! if @result.blasted.to_i > 0
    flee! if @result.fled.to_i > 0
    capture! if @result.captured.to_i > 0 && @result.captor
  end

  def blast!
    unload_carrier if @result.blasted == @fleet.quantity
    @result.update(final_quantity: @fleet.quantity - @result.blasted)
    @fleet.update(quantity: @fleet.quantity - @result.blasted)
  end

  def flee!
    unload_carrier
    @result.update(final_quantity: @fleet.quantity - @result.fled)
    if @result.movable?
      destination_planet = Route.in_range_for(@fleet)[rand(Route.in_range_for(@fleet).count)]
      routes = Route.in_range_for(@fleet)
      best_routes = routes.select { |planet| planet.fleets.any? { |fleet| fleet.squad == @fleet.squad } && !planet.under_attack? }
      destination_planet = best_routes[rand(best_routes.count)] if best_routes.count > 0
    else
      destination_planet = @result.planet
    end
    fleeing_fleet = @fleet.dup
    fleeing_fleet.update(quantity: @result.fled, planet: destination_planet)
    @fleet.update(quantity: @fleet.quantity - @result.fled)
  end

  def capture!
    unload_carrier
    #@result.update(final_quantity: @fleet.quantity - @result.captured)
    captured_fleet = @fleet.dup
    captured_fleet.update(quantity: @result.captured, squad: @result.captor)
    @fleet.update(quantity: @fleet.quantity - @result.captured)
  end

  def unload_carrier
    cargo = @fleet.cargo
    #cargo.each do |c|
      #ShipFleet.new(c.quantity, c, @fleet).disembark!
    #end
    cargo.update_all(carrier_id: nil)
  end
end
