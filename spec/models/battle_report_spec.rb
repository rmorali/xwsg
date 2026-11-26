require 'rails_helper'

RSpec.describe BattleReport, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :round }
    it { is_expected.to belong_to :squad }
  end

  describe 'validations' do
    subject { create(:battle_report) }

    it { is_expected.to validate_uniqueness_of(:squad_id).scoped_to(:round_id) }
    it { is_expected.to validate_length_of(:content).is_at_most(1500) }
  end
end