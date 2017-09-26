class UnloadFleet
  def initialize(quantity, cargo, carrier)
    @quantity = quantity
    @cargo = cargo
    @carrier = carrier
    return nil if @quantity < 1
  end

  def disembark
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
