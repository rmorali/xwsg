class LoadFleet
  def initialize(quantity, cargo, carrier)
    @quantity = quantity
    @cargo = cargo
    @carrier = carrier
    return nil if @quantity < 1
  end

  def embark
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

end
