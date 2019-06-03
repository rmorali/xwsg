class Combats
  def initialize
    
  end

  def create!
    Fleet.all.each do |f|
      moving = nil
      moving = true unless f.destination.nil?
      Combat.create(round: f.round, unit: f.unit, fleet: f, squad: f.squad, planet: f.planet, quantity: f.quantity, moving: moving)
    end  
  end
end
