class Planet < ApplicationRecord
  scope :seen_by, ->(squad) { joins(:fleets).where(fleets: {squad: squad}).group("planets.id") }
  scope :fog_seen_by, ->(squad) { joins(:results).where(results: {squad: squad}).group("planets.id") }

  serialize :domination, Hash
  has_many :fleets
  has_many :results

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
    fleets_seen = []
    fleets.sort_by { |a| [a.squad.name, a.unit.id, a.quantity] }.each do |fleet|
      fleets_seen << fleet if fleet.squad == squad
    end
    fleets_seen
    #TODO: Show enemy fleets produced before current round if squad has a radar
  end

  def fleets_presence
    presence = []
    squads.each do |squad|
      presence << [ squad, fleets.where(squad: squad).sum { |f| f.quantity * f.credits } ]
    end
    presence
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
