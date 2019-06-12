class ArmFleet
  def initialize(fleet, quantity, weapon = nil)
    @fleet = fleet
    @quantity = quantity
    @weapon = weapon unless weapon.nil?
  end

  def arm!

  end

  def disarm!

  end


end