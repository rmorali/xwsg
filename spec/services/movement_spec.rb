require 'rails_helper'

RSpec.describe Movement, type: :service do
  let(:fleet) { create(:fleet) }
  let(:unit) { create(:unit) }
  let(:squad) { create(:squad) }

  context 'movement' do
    before do
      @origin = create(:planet)
      @destination = create(:planet)
      Route.create(vector_a: @origin, vector_b: @destination, distance: 2)
      @fleet = create(:fleet, quantity: 10, unit: unit, squad: squad, planet: @origin, round: Round.current)
    end
    it 'orders a fleet to move' do
      Movement.new(@fleet, 10, @destination).order!
      expect(@fleet.destination).to eq(@destination)
    end
    it 'calculates the round of arrival' do
      Movement.new(@fleet, 10, @destination).order!
      expect(@fleet.arrives_in).to eq(2)
    end
    it 'brings its cargo with it' do
      fleet.carrier = @fleet
      fleet.save
      expect(@fleet.cargo).to include(fleet)
      Movement.new(@fleet, 10, @destination).order!
      expect(fleet.reload.destination).to eq(@destination)
    end
    it 'splits a fleet in a partial movement' do
      Movement.new(@fleet, 6, @destination).order!
      expect(Fleet.count).to_not eq(1)
      expect(@fleet.quantity).to eq(6)
      expect(@fleet.destination).to eq(@destination)
      expect(Fleet.last.quantity).to eq(4)
      expect(Fleet.last.destination).to_not eq(@destination)
    end
    it 'unloads cargo in a partial movement' do
      fleet.carrier = @fleet
      fleet.save
      expect(@fleet.cargo).to include(fleet)
      Movement.new(@fleet, 6, @destination).order!
      expect(@fleet.cargo).to_not include(fleet)
    end
    it 'cancel movement orders but doesnt unload carried fleets' do
      fleet.carrier = @fleet
      fleet.save
      Movement.new(@fleet, 10, @destination).order!
      expect(@fleet.destination).to eq(@destination)
      expect(fleet.reload.destination).to eq(@destination)
      Movement.new(@fleet, 0, @destination).order!
      expect(@fleet.destination).to eq(nil)
      expect(fleet.reload.destination).to eq(nil)
      expect(fleet.reload.carrier).to eq(@fleet)
    end
  end
end
