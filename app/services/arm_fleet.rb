class ArmFleet
  def initialize(fleet, quantity, armament = nil)
    @fleet = fleet
    @squad = fleet.squad
    @quantity = quantity
    @quantity = fleet.quantity if quantity > fleet.quantity
    @armament = armament unless armament.nil?
  end

  def arm!
  	if valid?
  	  arming_fleet = @fleet.dup
  	  arming_fleet.update(quantity: @quantity, armament: @armament)
      @fleet.update(quantity: @fleet.quantity - @quantity )    
    end
  end

  def disarm!

  end

  def valid?
    credits = @armament.credits * @quantity
    @squad.debit_resources(credits)
  end
end
