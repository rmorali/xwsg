class Shipment
  def initialize(quantity, cargo, carrier)
    @quantity = quantity
    @cargo = cargo
    @carrier = carrier
  end

  def embark!
    if @cargo.unit.weight * @quantity > @carrier.available_capacity
      @quantity = (@carrier.available_capacity / @cargo.unit.weight).round
    end
    return nil if @quantity < 1 || @cargo.nil? || @carrier.nil?
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
    return nil if @quantity < 1 || @cargo.nil? || @carrier.nil?
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
