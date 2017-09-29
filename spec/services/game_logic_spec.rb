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
    it 'executes logis accordingly to the round phase' do

    end
  end

  context 'new game' do

  end

  context 'strategy phase' do

  end

  context 'space combat phase' do
    it 'updates travelling fleets situation ' do

    end
    it 'updates arriving fleets location' do

    end
    it 'updates fleets and facilities producing situation' do

    end
    it 'complete producing fleets and facilities' do

    end
  end


end
