class SetWormhole
  def initialize
    @setup = Setup.current
  end

  def create!
  	@setup.initial_wormholes.times do
  	  vector_a = Planet.random
  	  vector_b = Planet.random	
  	  Route.create(vector_a: vector_a, vector_b: vector_b, distance: 2, wormhole: true)	
  	end
  end

end