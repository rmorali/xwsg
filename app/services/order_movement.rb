class OrderMovement
  def initialize(fleet,quantity,destination)
    @fleet = fleet
    @quantity = quantity
    @destination = destination
    self.cancel_move! if @quantity == 0 || @destination == nil
  end

  def move!
    unless @quantity == @fleet.quantity || @quantity == 0
      left_behind = @fleet.dup
      left_behind.quantity = @fleet.quantity - @quantity
      left_behind.save
      @fleet.cargo.each { |cargo| cargo.update_attributes(carrier: nil) }
      @fleet.update_attributes(quantity: @quantity)
    end
    @fleet.update_attributes(destination: @destination, arrives_in: self.arrives_in)
    @fleet.cargo.each { |cargo| cargo.update_attributes(destination: @destination, arrives_in: self.arrives_in) }
  end

  def arrives_in
    @fleet.round.number + Route.cost(@fleet.planet,@destination)
  end

  def cancel_move!
    @fleet.update_attributes(destination: nil, arrives_in: nil)
    @fleet.cargo.each { |cargo| cargo.update_attributes(destination: nil, arrives_in: nil) }
  end
end