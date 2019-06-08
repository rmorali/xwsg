class Planet < ApplicationRecord
  scope :seen_by, ->(squad) { joins(:fleets).where(fleets: {squad: squad}).group("planets.id") }
  scope :fog_seen_by, ->(squad) { joins(:results).where(results: {squad: squad}).group("planets.id") }

  serialize :domination, Hash
  has_many :fleets
  has_many :results

  def income
    @setup = Setup.current
    credits * @setup.planet_income_ratio
  end

  def image
    "planets/#{name.downcase}.png"
  end

  def under_attack?
    return true if fleets.distinct.count('squad_id') > 1
  end

  def fog_seen_by(squad)
    fog = []
    results.sort_by { |a| [a.round.number, a.squad.name, a.unit.id, a.quantity] }.each do |result|
      fog << result if result.round.number >= results.maximum("round_id") && result.squad != squad
    end
    fog
  end

  def fleets_seen_by(squad)
    round = Round.current
    seen_fleet = []
    seen_fleets = fleets.sort_by { |a| [a.squad.name, a.unit.id, a.quantity] } 
    seen_fleets.reject! { |fleet| fleet.squad != squad } if round.strategy?
    seen_fleets
    #TODO: Show enemy fleets produced before current round if squad has a radar
  end

  def fleets_influence
    influence = []
    squads.each do |squad|
      influence << [ squad, fleets.where(squad: squad).sum { |f| f.quantity * f.credits * f.influence_ratio} ]
    end
    influence
  end

  def squads
    squads = []
    fleets.each do |f|
      squads << f.squad
    end
    squads.uniq
  end

  def self.random
    planets = Planet.all.select { |p| p.fleets.empty? }
    planet = planets[rand(planets.count)]
    planet
  end
  # TODO: Verify if a squad can build facilities, produce units etc
end
