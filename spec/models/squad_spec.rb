require 'rails_helper'

RSpec.describe Squad, type: :model do
  let(:squad) { create(:squad) }

  describe 'associations' do
    it { is_expected.to have_many :fleets }
    it { is_expected.to belong_to :faction }
    it { is_expected.to have_many :users }
    it { is_expected.to have_many :messages }
    it { is_expected.to have_many(:battle_reports).dependent(:destroy) }
  end

  describe '#ready!' do
    it 'toggles ready state and triggers GameLogic#check_state!' do
      game_logic = instance_double(GameLogic, check_state!: true)
      allow(GameLogic).to receive(:new).and_return(game_logic)

      expect(squad.ready?).to be false

      squad.ready!
      expect(squad.reload.ready?).to be true

      squad.ready!
      expect(squad.reload.ready?).to be false
      expect(game_logic).to have_received(:check_state!).twice
    end
  end

  describe '#debit_credits and #debit_resources' do
    before { squad.update!(credits: 1000) }

    it 'debits credits only when balance is sufficient' do
      expect(squad.debit_credits(1500)).to be_nil
      expect(squad.reload.credits).to eq(1000)

      expect(squad.debit_credits(1000)).to be true
      expect(squad.reload.credits).to eq(0)
    end

    it 'returns false in debit_resources when cost exceeds credits' do
      expensive_unit = create(:unit, credits: 2000)
      expect(squad.debit_resources(expensive_unit.credits)).to be false
      expect(squad.reload.credits).to eq(1000)

      squad.update!(credits: 2000)
      expect(squad.debit_resources(expensive_unit.credits)).to be true
      expect(squad.reload.credits).to eq(0)
    end
  end

  describe '#image' do
    it 'returns the lowercase faction emblem path' do
      faction = create(:faction, name: 'Mandalorians')
      mandalorian_squad = create(:squad, faction: faction)

      expect(mandalorian_squad.image).to eq('squads/mandalorians.png')
    end
  end
end