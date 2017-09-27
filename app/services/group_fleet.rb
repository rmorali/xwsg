class GroupFleet
  def initialize(planet)
    @planet = planet
  end

  def group!
    groups.each do |duplicates|
      first_one = duplicates.shift
      duplicates.each do |double|
        next unless first_one.groupable
        first_one.increment!(:quantity, double.quantity)
        double.destroy
      end
    end
  end

  private

  def groups
    @planet.fleets.group_by do |fleet|
      fleet_attributes(fleet)
    end.values
  end

  def fleet_attributes(fleet)
    [
      fleet.unit,
      fleet.planet,
      fleet.squad,
      fleet.moving?,
      fleet.destination,
      fleet.arrives_in,
      fleet.carrier,
      fleet.ready_in
    ]
  end
end
