class OrderMovement
  def initialize(fleet,quantity,destination)
    @fleet = fleet
    @quantity = quantity
    @destination = destination
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
end
