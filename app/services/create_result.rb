class CreateResult
  def initialize

  end

  def create!
    round = Round.current
    planets = Planet.select { |p| p.under_attack? }
    planets.each do |p|
      description = attack_distance
      description << attack_order
      p.fleets.each do |f|
        f.update(level: f.level += 1)
        carrier = Result.where(fleet: f.carrier).last
        Result.create(round: round, unit: f.unit, fleet: f, squad: f.squad, planet: f.planet,
                      quantity: f.quantity, carrier: carrier, destination: f.destination,
                      arrives_in: f.arrives_in, ready_in: f.ready_in, description: description)
      end
    end
  end

  def attack_order
    params = "Iniciativa de ataque:<br>"
    order = Squad.all.sample(Squad.count)
    i = 1
    order.each do |o|
      params << "<span style='color: #{o.color}; font-weight: bold'>"
      params << "#{ i }.º #{o.name}<br>"
      params << "</span>"
      i += 1
    end
    params
  end

  def attack_distance
    distance = rand(3..7)
    params = "Distancia de ataque:<br>"
    params << "<span style='font-weight: bold; font-size: 12px'> #{distance}km </span><br><br>"
    params
  end

end
