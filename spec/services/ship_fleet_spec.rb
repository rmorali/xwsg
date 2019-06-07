require 'rails_helper'

RSpec.describe ShipFleet, type: :service do
  let(:planet) { create(:planet) }
  let(:squad) { create(:squad) }
  before do
    @strike_cruiser = create(:unit, capacity: 20)
    @capital_ship = create(:fleet, unit: @strike_cruiser, squad: squad, planet: planet)
    @xwing = create(:fleet, quantity: 10, squad: squad, planet: planet)
    @ywing = create(:fleet, quantity: 10, squad: squad, planet: planet)
    @bwing = create(:fleet, quantity: 5, squad: squad, planet: planet)
  end
  context 'embark fleets' do
    it 'only embarks fleets that carrier can afford to' do
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      ShipFleet.new(10, @ywing, @capital_ship).embark!
      ShipFleet.new(5, @bwing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
      expect(@capital_ship.cargo).to_not include(@bwing)
      ShipFleet.new(10, @xwing, @capital_ship).disembark!
      ShipFleet.new(5, @bwing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@bwing)
    end
    it 'embarks fleets until reachs carrier capacity' do
      @ywing.unit.update(weight: 3)
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      ShipFleet.new(10, @ywing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
      expect(@capital_ship.cargo.first.quantity).to eq(10)
      expect(@capital_ship.cargo.last.quantity).to eq(3)
      expect(Fleet.last.quantity).to eq(7)
      ShipFleet.new(3, @ywing, @capital_ship).disembark!
      corvette = create(:unit, weight: 15)
      @corvette = create(:fleet, quantity: 1, unit: corvette)
      ShipFleet.new(1, @corvette, @capital_ship).embark!
      expect(@capital_ship.cargo).to_not include(@corvette)
    end
    it 'embarks fleet in a carrier' do
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      ShipFleet.new(10, @ywing, @capital_ship).embark!
      expect(@xwing.carrier).to be @capital_ship
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo).to include(@ywing)
    end
    it 'splits a partially embarked fleet' do
      ShipFleet.new(6, @xwing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(6)
      expect(Fleet.last.quantity).to eq(4)
    end
  end
  context 'disembark fleets' do
    it 'disembarks a fleet from a carrier' do
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@xwing)
      ShipFleet.new(10, @xwing, @capital_ship).disembark!
      expect(@capital_ship.cargo).to_not include(@xwing)
    end
    it 'splits a partially disembarked fleet' do
      ShipFleet.new(10, @xwing, @capital_ship).embark!
      expect(@capital_ship.cargo).to include(@xwing)
      ShipFleet.new(6, @xwing, @capital_ship).disembark!
      expect(@capital_ship.cargo).to_not include(@xwing)
      expect(@capital_ship.cargo.first.quantity).to eq(4)
      expect(@xwing.quantity).to eq(6)
    end
  end
  it 'updates cargo destination on embarking and disembarking' do
    Route.create(vector_a: @capital_ship.planet, vector_b: planet, distance: 1)
    ShipFleet.new(10, @xwing, @capital_ship).embark!
    MoveFleet.new(@capital_ship, 1, planet).order!
    @xwing.reload
    expect(@xwing.destination).to eq(planet)
    expect(@xwing.arrives_in).to eq(@capital_ship.arrives_in)
    ShipFleet.new(6, @xwing, @capital_ship).disembark!
    expect(@xwing.destination).to eq(nil)
    expect(@xwing.arrives_in).to eq(nil)
  end
end
