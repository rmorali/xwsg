require 'rails_helper'

RSpec.describe Fleet, type: :model do
  let(:fleet) { create(:fleet) }
  let(:planet) { create(:planet) }
  let(:squad) { create(:squad) }
  let(:unit) { create(:unit, capacity: 20) }
  let(:setup) { create(:setup) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }
  it { is_expected.to belong_to :carrier }
  it { is_expected.to belong_to :destination }
  it { is_expected.to belong_to :armament }
  it { is_expected.to have_many :results }

  it 'delete fleet if empty' do
    @fleet = fleet
    expect(Fleet.all).to_not be_empty
    @fleet.update(quantity: 0)
    expect(Fleet.all).to be_empty
  end

  context 'scopes' do
    before do
      fleet.unit.producing_time = 1
      fleet.unit.terrain = 'Space'
      fleet.unit.save
      fleet.round = Round.current
      fleet.save
    end
    it 'finds units from specific terrain' do
      expect(Fleet.terrain('Ground')).to_not include(fleet)
      expect(Fleet.terrain('Space')).to include(fleet)
    end
    it 'finds enemies fleets' do
      enemy = create(:squad)
      create(:fleet, squad: enemy)
      expect(Fleet.enemy_of(fleet.squad)).to_not include(fleet)
      expect(Fleet.enemy_of(enemy)).to include(fleet)
    end
  end

  context 'fleet abilities and states' do
    before do
      @setup = setup
      @strike_cruiser = create(:unit, capacity: 20, hyperdrive: 0)
      @shipyard = create(:unit, type: 'Facility', carriable: false)
      @capital_ship = create(:fleet, unit: @strike_cruiser, squad: squad, planet: planet)
      @facility = create(:fleet, unit: @shipyard, squad: squad, planet: planet, ready_in: 1)
      @xwing = create(:fleet, quantity: 10, squad: squad, planet: planet)
      @ywing = create(:fleet, quantity: 10, squad: squad, planet: planet)
      @bwing = create(:fleet, quantity: 1, squad: squad, planet: planet)
    end
    it 'is movable?' do
      expect(@capital_ship.movable?).to_not be true
      @capital_ship.unit.update(hyperdrive: 1)
      expect(@capital_ship.movable?).to be true
      expect(@facility.movable?).to_not be true
      @facility.update(ready_in: 0)
      expect(@facility.movable?).to be true

    end
    it 'is in production?' do
      expect(@capital_ship.in_production?).to_not be true
    end
    it 'is moving?' do
      expect(@capital_ship.moving?).to_not be true
      @capital_ship.update(destination: planet)
      expect(@capital_ship.moving?).to be true
    end
    it 'is builder?' do
      expect(@capital_ship.builder?).to_not be true
      @setup.update(builder_unit: 'CapitalShip')
      expect(@capital_ship.builder?).to_not be true
      @setup.update(minimum_fleet_for_build: 1)
      expect(@capital_ship.builder?).to be true
      @facility.update(ready_in: 0)
      expect(@facility.builder?).to be true
    end
    it 'is loadable?' do
      expect(@capital_ship.loadable?).to be true
      expect(@xwing.loadable?).to_not be true
    end
    it 'returns its total weight' do
      expect(@capital_ship.weight).to eq(@capital_ship.quantity * @capital_ship.unit.weight)
    end
    it 'return its total capacity' do
      expect(@capital_ship.capacity).to eq(@capital_ship.quantity * @capital_ship.unit.capacity)
    end
    it 'returns its used capacity' do
      expect(@capital_ship.used_capacity).to eq(@capital_ship.capacity - @capital_ship.available_capacity)
    end
    it 'returns its available capacity' do
      @capital_ship.unit.update(capacity: 20)
      @capital_ship.update(quantity: 2)
      expect(@capital_ship.available_capacity).to eq(40)
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      expect(@capital_ship.available_capacity).to eq(30)
    end
    it 'finds carriable fleets' do
      expect(@capital_ship.carriables).to contain_exactly(@xwing, @ywing, @bwing)
      @xwing.update(destination: planet)
      expect(@capital_ship.carriables).to_not include(@xwing)
      @bwing.unit.update(weight: 21)
      expect(@capital_ship.carriables).to_not include(@bwing)
      @ywing.unit.update(carriable: false)
      expect(@capital_ship.carriables).to_not include(@ywing)
    end
    it 'returns fleet influence' do
      @fleet = fleet
      fleet_influence = @fleet.quantity * @fleet.credits * @fleet.influence_ratio
      expect(@fleet.influence).to eq(fleet_influence)
    end
  end
end
