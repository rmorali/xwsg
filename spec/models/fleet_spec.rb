require 'rails_helper'

RSpec.describe Fleet, type: :model do
  let(:fleet) { create(:fleet) }
  let(:planet) { create(:planet) }
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

  context 'carriers and cargoes' do
    before do
      @capital_ship = create(:fleet, unit: unit)
      @xwing = create(:fleet, quantity: 10)
      @ywing = create(:fleet, quantity: 10)
      @bwing = create(:fleet, quantity: 5)
    end
    it 'carrier has available capacity' do
      @capital_ship.update(quantity: 2)
      expect(@capital_ship.available_capacity).to eq(40)
      @capital_ship.embark(5, @xwing)
      expect(@capital_ship.available_capacity).to eq(35)
    end
    it 'has total fleet weight' do
      expect(@xwing.weight).to eq(@xwing.quantity * @xwing.unit.weight)
    end
    it 'only embarks fleets that carrier can afford to' do
      @capital_ship.embark(10, @xwing)
      @capital_ship.embark(10, @ywing)
      @capital_ship.embark(5, @bwing)
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
      expect(@capital_ship.cargo).to_not include(@bwing)
      @capital_ship.disembark(10, @xwing)
      @capital_ship.embark(5, @bwing)
      expect(@capital_ship.cargo).to include(@bwing)
    end
    it 'embarks fleets until reachs carrier capacity' do
      @ywing.unit.weight = 3
      @ywing.unit.save
      @ywing.update(quantity: 5)
      @capital_ship.embark(10, @xwing)
      @capital_ship.embark(5, @ywing)
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
      expect(@capital_ship.cargo.first.quantity).to eq(10)
      expect(@capital_ship.cargo.last.quantity).to eq(3)
      expect(Fleet.last.quantity).to eq(2)
      @capital_ship.disembark(3, @ywing)
      corvette = create(:unit, weight: 15)
      @corvette = create(:fleet, quantity: 1, unit: corvette)
      @capital_ship.embark(1, @corvette)
      expect(@capital_ship.cargo).to_not include(@corvette)
    end
    it 'embarks fleet in a carrier' do
      @capital_ship.embark(10, @xwing)
      @capital_ship.embark(10, @ywing)
      expect(@xwing.carrier).to be @capital_ship
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
    end
    it 'splits a partially embarked fleet' do
      @capital_ship.embark(6, @xwing)
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(6)
      expect(Fleet.last.quantity).to eq(4)
    end
    it 'disembarks a fleet from a carrier' do
      @capital_ship.embark(10, @xwing)
      expect(@capital_ship.cargo).to include(@xwing)
      @capital_ship.disembark(10, @xwing)
      expect(@capital_ship.cargo).to_not include(@xwing)
    end
    it 'splits a partially disembarked fleet' do
      @capital_ship.embark(10, @xwing)
      expect(@capital_ship.cargo).to include(@xwing)
      @capital_ship.disembark(6, @xwing)
      expect(@capital_ship.cargo).to_not include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(4)
      expect(@xwing.quantity).to eq(6)
    end
    it 'updates cargo destination on embarking and disembarking' do
      Route.create(vector_a: @capital_ship.planet, vector_b: planet, distance: 1)
      @capital_ship.embark(10, @xwing)
      OrderMovement.new(@capital_ship, 1, planet).move!
      @xwing.reload
      expect(@xwing.destination).to eq(planet)
      expect(@xwing.arrives_in).to eq(@capital_ship.arrives_in)
      @capital_ship.disembark(6, @xwing)
      expect(@xwing.destination).to eq(nil)
      expect(@xwing.arrives_in).to eq(nil)
    end
  end
end
