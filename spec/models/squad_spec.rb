require 'rails_helper'

RSpec.describe Squad, type: :model do
  let(:squad) { create(:squad) }

  it { is_expected.to have_many :fleets }
  it { is_expected.to belong_to :faction }
  it { is_expected.to have_many :users }

  it 'switch squad states' do
    squad.ready!
    expect(squad.ready?).to be true
    squad.ready!
    expect(squad.ready?).to_not be true
  end

  context 'credits and resources' do
    before do
      squad.credits = 1000
      squad.save
    end

    it 'debits credits if available' do
      expect(squad.debit_credits(1500)).to_not be(true)
      squad.debit_credits(1000)
      expect(squad.credits).to eq(0)
    end

    it 'debits resources as needed' do
      unit = create(:unit, credits: 2000)
      squad.debit_resources(unit.credits)
      expect(squad.credits).to eq(1000)
      squad.update(credits: 2000)
      squad.debit_resources(unit.credits)
      expect(squad.credits).to eq(0)
    end
  end

  it 'shows squad image' do
    
  end
end
