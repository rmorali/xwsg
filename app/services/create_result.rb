class CreateResult
  def initialize

  end

  def create!
    round = Round.current
    planets = Planet.select { |p| p.under_attack? }
    planets.each do |p|
      p.fleets.each do |f|
        moving = nil
        moving = true unless f.destination.nil?
        Result.create(round: round, unit: f.unit, fleet: f, squad: f.squad, planet: f.planet, quantity: f.quantity, moving: moving)
      end
    end
  end
end
