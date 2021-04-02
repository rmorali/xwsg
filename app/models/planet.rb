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
    round = Round.current
    fog = []
    results.sort_by { |a| [a.round.number, a.squad.name, a.unit.id, a.quantity] }.each do |result|
      last_seen_round = result.planet.results.maximum("round_id")
      fog << result if result.round.id == last_seen_round && result.squad != squad && round.strategy?
      #fog.reject! { |fleet| fleet.planet.results.none? { |f| f.squad == squad && f.round.id == last_seen_round } }
      #fog << result if result.round.id == result.planet.results.maximum("round_id") && result.squad != squad && !result.planet.fleets.any? { |f| f.squad == squad && f.squad != squad } && round.strategy?
      #fog.reject! { |fleet| fleet.planet.results.none? { |f| f.squad == squad && f.round.id == f.planet.results.maximum("round_id") } }
    end
    fog.reject! { |result| result.planet.results.none? { |f| f.squad == squad } }
    fog
  end

  def fleets_seen_by(squad)
    round = Round.current
    seen_fleets = []
    seen_fleets = fleets.sort_by { |a| [a.squad.name, a.unit.id, a.quantity] } if fleets.any? { |f| f.squad == squad }
    seen_fleets.reject! { |fleet| fleet.squad != squad } if round.strategy?
    seen_fleets
    #TODO: Show enemy fleets produced before current round if squad has a radar
  end

  def fleets_seen_by_radar(squad)
    round = Round.current
    seen_fleets = []
    Route.in_range_for(self).each do |route|
      if route.fleets.any? { |u| u.radar? && u.squad == squad}
        seen_fleets = fleets.sort_by { |a| [a.squad.name, a.unit.id, a.quantity] }
        seen_fleets.reject! { |fleet| fleet.squad == squad || !fleet.visible_by_radar? || fleet.round == round }
      end
    end
    seen_fleets
  end

  def fleets_influence
    influence = []
    squads.each do |squad|
      influence << [ squad, fleets.select { |f| f.squad == squad }.sum { |f| f.influence } ]
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

  def wormhole?
    true if routes.any? { |route| route.wormhole? }
  end

  def wormhole_to
    params = "Wormhole para: "
    wormhole = routes.last
    if wormhole.vector_a == self
      params << wormhole.vector_b.name
    else
      params << wormhole.vector_a.name
    end
    params
  end

  def routes
    Route.where('vector_a == ? OR vector_b == ?', self, self).uniq
  end

  def results
    Result.where(planet: self)
  end
end
