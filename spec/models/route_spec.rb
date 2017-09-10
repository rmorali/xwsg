require 'rails_helper'

RSpec.describe Route, type: :model do
  let(:route) { build(:route) }
  
  before do
    @planet_a = create(:planet)
    @planet_b = create(:planet)
    @planet_c = create(:planet)
    @planet_d = create(:planet)
    @route_1 = create(:route, vector_a: @planet_a, vector_b: @planet_b, distance: 1) 
    @route_2 = create(:route, vector_a: @planet_b, vector_b: @planet_c, distance: 1)
    @route_3 = create(:route, vector_a: @planet_c, vector_b: @planet_d, distance: 1)
  end
 
  it 'returns back and forth routes' do
    edges = Route.getEdges
    expect(edges.count).to eq(6)
    # Dijkstra Gem doesnt calculates reverse path. I had to create back and forth routes...
  end

  context 'related to paths' do
    
    it 'finds them' do
      edges = Route.getEdges
      path = Dijkstra.new(@planet_a, @planet_d, edges)
      expect(path.shortest_path).to contain_exactly(@planet_a, @planet_b, @planet_c, @planet_d)
      path = Dijkstra.new(@planet_d, @planet_a, edges)
      expect(path.shortest_path).to contain_exactly(@planet_d, @planet_c, @planet_b, @planet_a)
    end
  
    it 'calculates its cost' do
      edges = Route.getEdges
      path = Dijkstra.new(@planet_a, @planet_d, edges)
      expect(path.cost).to eq(3)
    end
    
    it 'finds the shortest one' do
      shortcut = create(:route, vector_a: @planet_a, vector_b: @planet_d, distance: 2)
      edges = Route.getEdges
      path = Dijkstra.new(@planet_a, @planet_d, edges)
      expect(path.cost).to eq(2)
    end
    
  end
 
end
