class CreateResult
  def initialize

  end

  def create!
    round = Round.current
    planets = Planet.select { |p| p.under_attack? }
    planets.each do |p|
      p.fleets.each do |f|
        carrier = Result.where(fleet: f.carrier).last
        Result.create(round: round, unit: f.unit, fleet: f, squad: f.squad, planet: f.planet,
                      quantity: f.quantity, carrier: carrier, destination: f.destination, arrives_in: f.arrives_in, ready_in: f.ready_in)
      end
    end
  end
end
