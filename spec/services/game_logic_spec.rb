require 'rails_helper'

RSpec.describe GameLogic, type: :service do
  let(:unit) { create(:unit) }
  before do
    @empire = create(:squad)
    @rebel = create(:squad)
    @round = Round.current
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
    it 'updates fleets and facilities producing situation' do
    end
    it 'complete producing fleets and facilities' do
    end
  end
end
