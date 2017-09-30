class UpdateFleet
  def moving
    moving_fleets = Fleet.where.not(destination: nil)
    moving_fleets.each { |fleet| fleet.update(arrives_in: fleet.arrives_in -= 1) }
    arriving_fleets = Fleet.where(arrives_in: 0)
    arriving_fleets.each { |fleet| fleet.update(planet: fleet.destination, destination: nil, arrives_in: nil) }
  end
  def building
    building_fleets = Fleet.where.not(ready_in: nil)
    building_fleets.each { |fleet| fleet.update(ready_in: fleet.ready_in -= 1) }
    built_fleets = Fleet.where(ready_in: 0)
    built_fleets.each { |fleet| fleet.update(ready_in: nil) }
  end
end
