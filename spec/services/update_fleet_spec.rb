require 'rails_helper'

RSpec.describe UpdateFleet, type: :service do
  let(:unit) { create(:unit) }
  let(:faction) { create(:faction) }
  let(:planet) { create(:planet) }
  before do
    @empire = create(:squad)
    @rebel = create(:squad)
    @round = Round.current
    @origin = create(:planet)
  end
  context 'moving fleets' do
    before do
      @destination = create(:planet)
      Route.create(vector_a: @origin, vector_b: @destination, distance: 1)
      @xwing = create(:fleet, quantity: 10, unit: unit, squad: @rebel, planet: @origin, round: Round.current)
      MoveFleet.new(@xwing, 10, @destination).order!
    end
    it 'updates travelling situation' do
      expect(@xwing.planet).to eq(@origin)
      expect(@xwing.arrives_in).to eq(1)
      UpdateFleet.new.move!
      expect(@xwing.reload.arrives_in).to be nil
      expect(@xwing.reload.planet).to eq(@destination)
    end
  end

  context 'producing and building fleets' do
    before do
      faction.save!
      @squad = create(:squad, credits: 1000, faction: faction)
      @shipyard = create(:unit, type: 'Facility', producing_time: 2, credits: 1)
      @strike_cruiser = create(:unit, type: 'CapitalShip', producing_time: 2, credits: 1)
    end
    it 'updates situation' do
      BuildFleet.new(1, @shipyard, @squad, @origin).build!
      expect(@origin.fleets).to_not be_empty
      expect(@origin.fleets.first.in_production?).to be true
      UpdateFleet.new.build!
      expect(@origin.fleets.first.in_production?).to be true
      UpdateFleet.new.build!
      expect(@origin.fleets.first.in_production?).to be false
    end
    it 'cancel updates if attacked or sabotaged' do
      # TODO: stops building on some situations
    end
  end
end
