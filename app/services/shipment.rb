class Shipment
  def initialize(quantity, cargo, carrier)
    @quantity = quantity
    @cargo = cargo
    @carrier = carrier
    return nil if @quantity < 1 || cargo == nil || carrier || nil
  end

  def embark!
    if @cargo.weight > @carrier.available_capacity
      @quantity = (@carrier.available_capacity / @cargo.unit.weight).round
      return nil if @quantity < 1
    end
    if @cargo.quantity == @quantity
      @cargo.update(carrier: @carrier, destination: @carrier.destination, arrives_in: @carrier.arrives_in)
    else
      left_behind = @cargo.dup
      left_behind.quantity = @cargo.quantity - @quantity
      left_behind.save
      @cargo.update(quantity: @quantity, carrier: @carrier, destination: @carrier.destination, arrives_in: @carrier.arrives_in)
    end
  end

  def disembark!
    if @cargo.quantity == @quantity
      @cargo.update(carrier: nil, destination: nil, arrives_in: nil)
    else
      left_inside = @cargo.dup
      left_inside.quantity = @cargo.quantity - @quantity
      left_inside.save
      @cargo.update(quantity: @quantity, carrier: nil, destination: nil, arrives_in: nil)
    end
  end
end