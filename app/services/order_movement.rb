class OrderMovement
  def initialize(fleet, quantity, destination)
    @fleet = fleet
    @quantity = quantity
    @destination = destination
    cancel_move! if @quantity.zero? || @destination.nil?
  end

  def move!
    unless @quantity == @fleet.quantity || @quantity.zero?
      left_behind = @fleet.dup
      left_behind.quantity = @fleet.quantity - @quantity
      left_behind.save
      @fleet.cargo.each { |cargo| cargo.update(carrier: nil) }
      @fleet.update(quantity: @quantity)
    end
    @fleet.update(destination: @destination, arrives_in: arrives_in)
    @fleet.cargo.each { |cargo| cargo.update(destination: @destination, arrives_in: arrives_in) }
  end

  def arrives_in
    @fleet.round.number + Route.cost(@fleet.planet, @destination)
  end

  def cancel_move!
    @fleet.update(destination: nil, arrives_in: nil)
    @fleet.cargo.each { |cargo| cargo.update(destination: nil, arrives_in: nil) }
  end
end
