require 'rails_helper'

RSpec.describe OrderMovement, type: :service do
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
      OrderMovement.new(@fleet, 10, @destination)
      expect(@fleet.destination).to eq(@destination)
    end
    it 'calculates the round of arrival' do
      OrderMovement.new(@fleet, 10, @destination)
      expect(@fleet.arrives_in).to eq(2)
    end
    it 'brings its cargo with it' do
      fleet.carrier = @fleet
      fleet.save
      expect(@fleet.cargo).to include(fleet)
      OrderMovement.new(@fleet, 10, @destination)
      expect(fleet.reload.destination).to eq(@destination)
    end
    it 'splits a fleet in a partial movement' do
      OrderMovement.new(@fleet, 6, @destination)
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
      OrderMovement.new(@fleet, 6, @destination)
      expect(@fleet.cargo).to_not include(fleet)
    end
    it 'cancel movement orders but doesnt unload carried fleets' do
      fleet.carrier = @fleet
      fleet.save
      OrderMovement.new(@fleet, 10, @destination)
      expect(@fleet.destination).to eq(@destination)
      expect(fleet.reload.destination).to eq(@destination)
      OrderMovement.new(@fleet, 0, @destination)
      expect(@fleet.destination).to eq(nil)
      expect(fleet.reload.destination).to eq(nil)
      expect(fleet.reload.carrier).to eq(@fleet)
    end
  end
end
