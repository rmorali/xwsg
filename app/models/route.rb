class Route < ApplicationRecord
  belongs_to :vector_a, class_name: 'Planet', foreign_key: 'vector_a'
  belongs_to :vector_b, class_name: 'Planet', foreign_key: 'vector_b'

  def self.edges
    edges = []
    Route.all.each do |r|
      edges << [r.vector_a, r.vector_b, r.distance]
      edges << [r.vector_b, r.vector_a, r.distance]
    end
    edges
  end

  def self.path(origin, destination)
    Dijkstra.new(origin, destination, edges).shortest_path
  end

  def self.cost(origin, destination)
    Dijkstra.new(origin, destination, edges).cost
  end

  def self.in_range_for(fleet = nil)
    if fleet.class.name == 'Planet'
      planets = []
      routes = Route.where("vector_a = ? or vector_b = ?", fleet, fleet)
      routes.each do |route|
        planets << route.vector_a
        planets << route.vector_b
      end
      planets.reject! { |planet| planet == fleet }
      return planets.uniq
    end
=begin    hyperdrive = fleet.unit.hyperdrive
    origin = fleet.planet
    edges = Route.edges
    destinations = []
    Planet.all.each do |planet|
      path = Dijkstra.new(origin, planet, edges).shortest_path
      path.each do |p|
        destinations << p if Dijkstra.new(origin, p, edges).cost <= hyperdrive
      end
    end
    destinations.reject { |r| r == origin }.uniq
=end
    return if fleet.hyperdrive.to_i < 1
    planets = []
    routes = Route.where("vector_a = ? or vector_b = ?", fleet.planet, fleet.planet)
    routes.each do |route|
      planets << route.vector_a
      planets << route.vector_b
    end
    planets.reject! { |planet| planet == fleet.planet }
    planets.reject! { |planet| !planet.fleets.any? { |f| f.squad == fleet.squad} } if fleet.type == 'Fighter'
    planets.uniq
  end

  def wormhole?
    wormhole
  end
end
