require 'rails_helper'

RSpec.describe MoveFleet, type: :service do
  let(:fleet) { create(:fleet) }
  let(:unit) { create(:unit) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }

  context 'movement' do
    before(:each) do
      @origin = planet
      @destination = create(:planet)
      Route.create(vector_a: @origin, vector_b: @destination, distance: 1)
      @fleet = fleet
      @fleet.update(quantity: 10, unit: unit, squad: squad, planet: @origin, round: Round.current)
    end
    it 'orders a fleet to move' do
      MoveFleet.new(@fleet, 10, @destination).order!
      expect(@fleet.destination).to eq(@destination)
    end
    it 'calculates the time to travel' do
      MoveFleet.new(@fleet, 10, @destination).order!
      expect(@fleet.arrives_in).to eq(1)
    end
    it 'takes its cargo with it' do
      fleet.update(carrier: @fleet)
      expect(@fleet.cargo).to include(fleet)
      MoveFleet.new(@fleet, 10, @destination).order!
      expect(fleet.reload.destination).to eq(@destination)
    end
    it 'splits a fleet in a partial movement' do
      # 1. Garantimos que a frota foi realmente dividida (um novo registro foi criado)
      expect {
        MoveFleet.new(@fleet, 6, @destination).order!
      }.to change(Fleet, :count).by(1)

      # 2. Recarregamos a frota original do banco e verificamos se ela virou a frota de viagem
      @fleet.reload
      expect(@fleet.quantity).to eq(6)
      expect(@fleet.destination).to eq(@destination)

      # 3. Buscamos especificamente o "pedaço" da frota que foi deixado para trás
      left_behind_fleet = Fleet.where.not(id: @fleet.id).last

      # 4. Verificamos se quem ficou para trás tem os atributos corretos
      expect(left_behind_fleet.quantity).to eq(4)
      expect(left_behind_fleet.destination).to_not eq(@destination)
    end
    it 'unloads cargo in a partial movement' do
      fleet.update(carrier: @fleet)
      expect(@fleet.cargo).to include(fleet)
      MoveFleet.new(@fleet, 6, @destination).order!
      expect(@fleet.cargo).to_not include(fleet)
    end
    it 'cancel movement orders but doesnt unload carried fleets' do
      fleet.update(carrier: @fleet)
      MoveFleet.new(@fleet, 10, @destination).order!
      expect(@fleet.destination).to eq(@destination)
      expect(fleet.reload.destination).to eq(@destination)
      MoveFleet.new(@fleet, 0, @destination).order!
      expect(@fleet.destination).to eq(nil)
      expect(fleet.reload.destination).to eq(nil)
      expect(fleet.reload.carrier).to eq(@fleet)
    end
  end
end
