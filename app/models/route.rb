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
    Dijkstra.new(origin, destination, self.edges).shortest_path
  end

  def self.cost(origin, destination)
    Dijkstra.new(origin, destination, self.edges).cost
  end

  def self.in_range(origin, hyperdrive)
    edges = Route.edges
    destinations = []
    Planet.all.each do |planet|
      path = Dijkstra.new(origin, planet, edges).shortest_path
      path.each do |p|
        destinations << p if Dijkstra.new(origin, p, edges).cost <= hyperdrive
      end
    end
    destinations.uniq
  end
end
