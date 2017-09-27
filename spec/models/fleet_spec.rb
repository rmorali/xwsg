require 'rails_helper'

RSpec.describe Fleet, type: :model do
  let(:fleet) { create(:fleet) }
  let(:planet) { create(:planet) }
  let(:squad) { create(:squad) }
  let(:unit) { create(:unit, capacity: 20) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }
  it { is_expected.to belong_to :carrier }
  it { is_expected.to belong_to :destination }

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
      @strike_cruiser = create(:unit, capacity: 20)
      @capital_ship = create(:fleet, unit: @strike_cruiser, squad: squad, planet: planet)
      @xwing = create(:fleet, quantity: 10, squad: squad, planet: planet)
      @ywing = create(:fleet, quantity: 10, squad: squad, planet: planet)
      @bwing = create(:fleet, quantity: 1, squad: squad, planet: planet)
    end
    it 'checks if it is movable' do
      expect(@capital_ship.movable?).to be true
      @capital_ship.unit.update(hyperdrive: nil)
      expect(@capital_ship.movable?).to_not be true
    end
    it 'checks if it is moving' do
      expect(@capital_ship.moving?).to_not be true
      @capital_ship.update(destination: planet)
      expect(@capital_ship.moving?).to be true
    end
    it 'calculate its total weight' do
      expect(@capital_ship.weight).to eq(@capital_ship.quantity * @capital_ship.unit.weight)
    end
    it 'calculate its available capacity' do
      @capital_ship.unit.update(capacity: 20)
      @capital_ship.update(quantity: 2)
      expect(@capital_ship.available_capacity).to eq(40)
      Shipment.new(10, @xwing, @capital_ship).embark!
      expect(@capital_ship.available_capacity).to eq(30)
    end
    it 'finds carriable fleets' do
      expect(@capital_ship.carriables).to contain_exactly(@xwing, @ywing, @bwing)
      @xwing.update(destination: planet)
      expect(@capital_ship.carriables).to_not include(@xwing)
      @bwing.unit.update(weight: 21)
      expect(@capital_ship.carriables).to_not include(@bwing)
    end
  end
end
