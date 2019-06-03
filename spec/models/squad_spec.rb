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
      squad.metals = 1000
      squad.save
    end

    it 'debits credits if available' do
      expect(squad.debit_credits(1500)).to_not be(true)
      squad.debit_credits(1000)
      expect(squad.credits).to eq(0)
    end

    it 'debits metals if available' do
      expect(squad.debit_metals(1500)).to_not be(true)
      squad.debit_metals(1000)
      expect(squad.metals).to eq(0)
    end

    it 'debits resources as needed' do
      unit = create(:unit, credits: 1000, metals: 1000)
      credits = unit.credits * 2
      metals = unit.metals * 2
      expect(squad.debit_resources(credits, metals)).to_not be(true)
      expect(squad.credits).to eq(1000)
      expect(squad.metals).to eq(1000)
      squad.update(credits: 2000, metals: 2000)
      expect(squad.debit_resources(credits, metals)).to be(true)
      expect(squad.credits).to eq(0)
      expect(squad.metals).to eq(0)
    end
  end
end
