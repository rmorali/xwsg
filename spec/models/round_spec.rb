require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { create(:round) }

  describe 'associations and enums' do
    it { is_expected.to have_many :fleets }
    it { is_expected.to have_many :results }
    it { is_expected.to have_many(:battle_reports).dependent(:destroy) }
    it { is_expected.to define_enum_for(:phase).with_values(strategy: 0, space_combat: 1, finished: 2) }
  end

  describe '.current' do
    it 'creates the first round if none exists' do
      Round.destroy_all
      expect(Round.count).to eq(0)

      current = Round.current
      expect(Round.count).to eq(1)
      expect(current).to eq(Round.last)
    end

    it 'returns the most recent round when rounds already exist' do
      first_round = create(:round)
      second_round = create(:round)

      expect(Round.current).to eq(second_round)
      expect(Round.current).not_to eq(first_round)
    end
  end

  describe '.results_for' do
    it 'returns only distinct rounds that have results for the given squad' do
      squad = create(:squad)
      other_squad = create(:squad)
      r1 = create(:round)
      r2 = create(:round)
      r3 = create(:round)

      create_list(:result, 2, round: r1, squad: squad)
      create(:result, round: r2, squad: other_squad)

      expect(Round.results_for(squad)).to contain_exactly(r1)
      expect(Round.results_for(squad)).not_to include(r2, r3)
    end
  end

  describe '#number' do
    it 'returns the round id as integer' do
      expect(round.number).to eq(round.id.to_i)
    end
  end

  describe '#next_phase!' do
    before do
      Round.destroy_all
      @round = create(:round, phase: :strategy)
    end

    it 'advances from strategy to space_combat and then to finished creating a new round' do
      expect(@round.strategy?).to be true

      @round.next_phase!
      expect(@round.reload.space_combat?).to be true
      expect(Round.count).to eq(1)

      @round.next_phase!
      expect(@round.reload.finished?).to be true
      expect(Round.count).to eq(2)
      expect(Round.last.strategy?).to be true
    end
  end
end