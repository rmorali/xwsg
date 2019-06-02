require 'rails_helper'

RSpec.describe Round, type: :model do
  let(:round) { create(:round) }

  it { is_expected.to have_many :fleets }

  it 'has a number' do
    expect(round.number).to eq(round.id.to_i)
  end

  it 'gets the current round' do
    expect(Round.current).to eq(Round.last)
  end

  it 'jumps to the next phase' do
    expect(round.phase).to eq(0)
    round.next_phase!
    expect(round.phase).to eq(1)
  end

  it 'starts a new round after the last phase' do
    expect(Round.count).to eq(1)
    expect(round.phase).to eq(0)
    round.next_phase!
    round.next_phase!
    expect(Round.count).to eq(2)
  end
end
