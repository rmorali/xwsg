class GetRoutes
  def initialize(*args)
      @origin = args[0]
    if args[1].is_a?(Integer)
      @cost = args[1]
    else
      @destination = args[1]
    end
  end

  def edges
    edges = []
    Route.all.each do |r|
      edges << [r.vector_a, r.vector_b, r.distance]
      edges << [r.vector_b, r.vector_a, r.distance]
    end
    edges
  end

  def shortest_path
    Dijkstra.new(@origin, @destination, self.edges).shortest_path
  end

  def cost
    Dijkstra.new(@origin, @destination, self.edges).cost
  end

  def in_range
    #TODO returns all planets in an specific range
  end

end
