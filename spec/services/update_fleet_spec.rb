require 'rails_helper'

RSpec.describe UpdateFleet, type: :service do
  let(:unit) { create(:unit) }
  let(:faction) { create(:faction) }
  before do
    @empire = create(:squad)
    @rebel = create(:squad)
    @round = Round.current
    @origin = create(:planet)
  end
  context 'moving fleets' do
    before do
      @destination = create(:planet)
      @far_destination = create(:planet)
      Route.create(vector_a: @origin, vector_b: @destination, distance: 1)
      Route.create(vector_a: @destination, vector_b: @far_destination, distance: 1)
      @xwing = create(:fleet, quantity: 10, unit: unit, squad: @rebel, planet: @origin, round: Round.current)
      @strike_cruiser = create(:fleet, quantity: 1, unit: unit, squad: @empire, planet: @origin, round: Round.current)
      OrderMovement.new(@xwing, 10, @destination).move!
      OrderMovement.new(@strike_cruiser, 1, @far_destination).move!
    end
    it 'updates travelling situation' do
      expect(@strike_cruiser.planet).to eq(@origin)
      expect(@strike_cruiser.arrives_in).to eq(2)
      UpdateFleet.new.moving
      expect(@strike_cruiser.reload.arrives_in).to eq(1)
      expect(@strike_cruiser.reload.planet).to eq(@origin)
    end
    it 'updates location at its arrival' do
      expect(@xwing.planet).to eq(@origin)
      UpdateFleet.new.moving
      expect(@xwing.reload.planet).to eq(@destination)
      expect(@strike_cruiser.reload.planet).to eq(@origin)
      UpdateFleet.new.moving
      expect(@strike_cruiser.reload.arrives_in).to eq(nil)
      expect(@strike_cruiser.reload.planet).to eq(@far_destination)
    end
  end
  context 'producing and building fleets' do
    before do
      faction.save!
      @squad = create(:squad, credits: 1000, metals: 1000, faction: faction)
      @shipyard = create(:unit, type: 'Facility', producing_time: 2, credits: 1, metals: 1)
      @strike_cruiser = create(:unit, type: 'CapitalShip', producing_time: 2, credits: 1, metals: 1)
    end
    it 'updates situation' do
      BuildUnit.new(@shipyard, @squad, @origin).build!
      expect(@origin.fleets).to_not be_empty
      expect(@origin.fleets.first.in_production?).to be true
      UpdateFleet.new.building
      expect(@origin.fleets.first.in_production?).to be true
      UpdateFleet.new.building
      expect(@origin.fleets.first.in_production?).to be false
    end
    it 'cancel updates if attacked or sabotaged' do
      # TODO: stops building on some situations
    end
  end
end
