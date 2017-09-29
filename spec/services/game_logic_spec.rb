require 'rails_helper'

RSpec.describe GameLogic, type: :service do
  let(:unit) { create(:unit) }
  before do
    @empire = create(:squad)
    @rebel = create(:squad)
    @round = Round.current
    @origin = create(:planet)
    @destination = create(:planet)
    @far_destination = create(:planet)
    Route.create(vector_a: @origin, vector_b: @destination, distance: 1)
    Route.create(vector_a: @destination, vector_b: @far_destination, distance: 1)
    @xwing = create(:fleet, quantity: 10, unit: unit, squad: @rebel, planet: @origin, round: Round.current)
    @strike_cruiser = create(:fleet, quantity: 1, unit: unit, squad: @empire, planet: @origin, round: Round.current)
    OrderMovement.new(@xwing, 10, @destination).move!
    OrderMovement.new(@strike_cruiser, 1, @far_destination).move!
  end

  context 'all squads ready' do
    before do
      @empire.ready!
    end
    it 'starts another phase' do
      GameLogic.new.check_state!
      expect(@round.phase).to eq(0)
      @rebel.ready!
      GameLogic.new.check_state!
      expect(@round.reload.phase).to eq(1)
    end
    it 'turns back their states' do
      @rebel.ready!
      GameLogic.new.check_state!
      expect(@rebel.reload.ready?).to_not eq(true)
      expect(@empire.reload.ready?).to_not eq(true)
    end
  end

  context 'check phases' do
    it 'executes logics accordingly to the round phase' do

    end
  end

  context 'new game' do

  end

  context 'strategy phase' do

  end

  context 'space combat phase' do
    before do
      @rebel.ready!
      @empire.ready!
    end
    it 'updates travelling fleets situation' do
      expect(@strike_cruiser.planet).to eq(@origin)
      expect(@strike_cruiser.arrives_in).to eq(2)
      GameLogic.new.check_state!
      expect(@strike_cruiser.reload.arrives_in).to eq(1)
      expect(@strike_cruiser.reload.planet).to eq(@origin)
    end
    it 'updates arriving fleets location' do
      expect(@xwing.planet).to eq(@origin)
      GameLogic.new.space_combat!
      expect(@xwing.reload.planet).to eq(@destination)
      expect(@strike_cruiser.reload.planet).to eq(@origin)
      GameLogic.new.space_combat!
      expect(@strike_cruiser.reload.arrives_in).to eq(nil)
      expect(@strike_cruiser.reload.planet).to eq(@far_destination)
    end
    it 'updates fleets and facilities producing situation' do

    end
    it 'complete producing fleets and facilities' do

    end
  end


end
