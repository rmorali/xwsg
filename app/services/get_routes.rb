class GetRoutes

  def edges
    edges = []
    Route.all.each do |r|
      edges << [r.vector_a, r.vector_b, r.distance]
      edges << [r.vector_b, r.vector_a, r.distance]
    end
    edges
  end

  def shortest_path(origin, destination)
    Dijkstra.new(origin, destination, self.edges).shortest_path
  end

  def cost(origin, destination)
    Dijkstra.new(origin, destination, self.edges).cost
  end

  def in_range(origin, hyperdrive)
    edges = self.edges
    destinations = []
    Planet.all.each do |planet|
      path = Dijkstra.new(origin, planet, edges).shortest_path
      path.each do |p|
        destinations << p if Dijkstra.new(origin, p, edges).cost <= hyperdrive
      end
    end
    destinations.uniq
    #TODO returns all planets in an specific range
  end

end
