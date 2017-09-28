require 'rails_helper'

RSpec.describe Route, type: :model do
  it { is_expected.to belong_to :vector_a }
  it { is_expected.to belong_to :vector_b }
  let(:route) { build(:route) }

  before do
    @planet_a = create(:planet)
    @planet_b = create(:planet)
    @planet_c = create(:planet)
    @planet_d = create(:planet)
    @route1 = create(:route, vector_a: @planet_a, vector_b: @planet_b, distance: 1)
    @route2 = create(:route, vector_a: @planet_b, vector_b: @planet_c, distance: 1)
    @route3 = create(:route, vector_a: @planet_c, vector_b: @planet_d, distance: 1)
    @fleet = create(:fleet, planet: @planet_a)
  end

  it 'returns back and forth edges' do
    edges = Route.edges
    expect(edges.count).to eq(6)
    # Dijkstra Gem doesnt calculates reverse path. I had to create back and forth routes...
  end

  it 'returns all planets within a unit autonomy' do
    nearby_destinations = Route.in_range_for(@fleet)
    expect(nearby_destinations).to contain_exactly(@planet_b)
    @fleet.unit.hyperdrive = 3
    @fleet.unit.save
    far_destinations = Route.in_range_for(@fleet)
    expect(far_destinations).to contain_exactly(@planet_b, @planet_c, @planet_d)
  end

  context 'related to paths' do
    it 'finds one' do
      path = Route.path(@planet_a, @planet_d)
      expect(path).to contain_exactly(@planet_a, @planet_b, @planet_c, @planet_d)
      path = Route.path(@planet_d, @planet_a)
      expect(path).to contain_exactly(@planet_d, @planet_c, @planet_b, @planet_a)
    end

    it 'calculates its cost' do
      cost = Route.cost(@planet_a, @planet_d)
      expect(cost).to eq(3)
    end

    it 'always finds the shortest one' do
      # shortcut
      create(:route, vector_a: @planet_a, vector_b: @planet_d, distance: 2)
      path = Route.path(@planet_a, @planet_d)
      expect(path).to contain_exactly(@planet_a, @planet_d)
      cost = Route.cost(@planet_a, @planet_d)
      expect(cost).to eq(2)
    end
  end

  # TODO: All of these methods are intended to receive only the moving fleet
end
