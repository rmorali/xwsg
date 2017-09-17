require 'rails_helper'

RSpec.describe Fleet, type: :model do

  let(:fleet) { create(:fleet) }
  let(:planet) { create(:planet) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }
  it { is_expected.to belong_to :carrier }
  it { is_expected.to belong_to :destination}

  context 'scopes' do
    before do
      fleet.unit.producing_time = 1
      fleet.unit.terrain = 'Space'
      fleet.unit.save
      fleet.round = Round.get_current
      fleet.save
    end
    it 'finds units in production' do
      expect(Fleet.in_production).to include(fleet)
      Round.create
      expect(Fleet.in_production).to_not include(fleet)
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

  context 'carriers and cargoes' do
    before do
      @capital_ship = create(:fleet)
      @xwing = create(:fleet, quantity: 10)
      @ywing = create(:fleet, quantity: 10)
    end
    it 'load fleet in a carrier' do
      @xwing.load_in(@capital_ship,10)
      @ywing.load_in(@capital_ship,10)
      expect(@xwing.carrier).to be @capital_ship
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
    end
    it 'splits a partially loaded fleet' do
      @xwing.load_in(@capital_ship,6)
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(6)
      expect(Fleet.last.quantity).to eq(4)
    end
    it 'unloads a fleet from a carrier' do
      @xwing.load_in(@capital_ship,10)
      expect(@capital_ship.cargo).to include(@xwing)
      @xwing.unload_from(@capital_ship,10)
      expect(@capital_ship.cargo).to_not include(@xwing)
    end
    it 'splits a partially unloaded fleet' do
      @xwing.load_in(@capital_ship,10)
      expect(@capital_ship.cargo).to include(@xwing)
      @xwing.unload_from(@capital_ship,6)
      expect(@capital_ship.cargo).to_not include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(4)
      expect(@xwing.quantity).to eq(6)
    end
    it 'updates cargo destination in loading or unloading' do
      Route.create(vector_a: @capital_ship.planet, vector_b: planet, distance: 1)
      @xwing.load_in(@capital_ship,10)
      OrderMovement.new(@capital_ship,1,planet).move!
      @xwing.reload
      expect(@xwing.destination).to eq(planet)
      expect(@xwing.arrives_in).to eq(@capital_ship.arrives_in)
      @xwing.unload_from(@capital_ship,6)
      expect(@xwing.destination).to eq(nil)
      expect(@xwing.arrives_in).to eq(nil)
    end
    it 'respects carrier load capacity' do

    end
  end

end
