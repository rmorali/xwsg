require 'rails_helper'

RSpec.describe GetRoutes, type: :service do
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

  it 'returns back and forth edges' do
    edges = GetRoutes.new.edges
    expect(edges.count).to eq(6)
    # Dijkstra Gem doesnt calculates reverse path. I had to create back and forth routes...
  end

  it 'returns all planets within a specific range' do
    nearby_destinations = GetRoutes.new.in_range(@planet_a, 1)
    expect(nearby_destinations).to contain_exactly(@planet_a, @planet_b)
    far_destinations = GetRoutes.new.in_range(@planet_a, 3)
    expect(far_destinations).to contain_exactly(@planet_a, @planet_b, @planet_c, @planet_d)
  end

  context 'related to paths' do

    it 'finds one' do
      path = GetRoutes.new.shortest_path(@planet_a, @planet_d)
      expect(path).to contain_exactly(@planet_a, @planet_b, @planet_c, @planet_d)
      path = GetRoutes.new.shortest_path(@planet_d, @planet_a)
      expect(path).to contain_exactly(@planet_d, @planet_c, @planet_b, @planet_a)
    end

    it 'calculates its cost' do
      cost = GetRoutes.new.cost(@planet_a, @planet_d)
      expect(cost).to eq(3)
    end

    it 'always finds the shortest one' do
      shortcut = create(:route, vector_a: @planet_a, vector_b: @planet_d, distance: 2)
      path = GetRoutes.new.shortest_path(@planet_a, @planet_d)
      expect(path).to contain_exactly(@planet_a, @planet_d)
      cost = GetRoutes.new.cost(@planet_a, @planet_d)
      expect(cost).to eq(2)
    end

  end

end
