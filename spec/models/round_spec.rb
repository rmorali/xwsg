require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { create(:round) }

  it { is_expected.to have_many :fleets }
  it { is_expected.to have_many :results }

  it 'creates the first round if it doesnt exist' do
    expect(Round.all).to be_empty
    Round.current
    expect(Round.all.count).to eq(1)
  end

  it 'has a number' do
    expect(round.number).to eq(round.id.to_i)
  end

  context 'managing phases' do
    before do
      Round.destroy_all
      @round = round
    end
    it 'gets the current round' do
      expect(Round.current).to eq(Round.last)
    end

    it 'manage phases and start new round after the last one' do
      expect(@round.strategy?).to be true
      round.next_phase!
      expect(@round.reload.space_combat?).to be true
      round.next_phase!
      expect(@round.reload.finished?).to be true
      expect(Round.count).to eq(2)
    end
  end
end
