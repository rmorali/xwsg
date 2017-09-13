require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { create(:round) }

  it { is_expected.to have_many :fleets }

  it 'has a number' do
    expect(round.number).to eq(round.id.to_i)
  end

  it 'gets the current round' do
    expect(Round.getCurrent).to eq(Round.last)
  end

  it 'has three phases' do
    round.strategy!
    expect(round.strategy?).to be true
    round.space_combat!
    expect(round.space_combat?).to be true
    round.ground_combat!
    expect(round.ground_combat?).to be true
  end


end
