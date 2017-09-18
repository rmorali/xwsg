require 'rails_helper'

RSpec.describe Squad, type: :model do
  let(:squad) { create(:squad) }

  it { is_expected.to have_many :fleets }
  it { is_expected.to belong_to :faction }
  it { is_expected.to have_many :users }

  context 'credits and resources' do
    before do
      squad.credits = 1000
      squad.metals = 1000
      squad.save
    end

    it 'debits credits if available' do
      expect(squad.debit(1500, 'credits')).to_not be(true)
      squad.debit(1000, 'credits')
      expect(squad.credits).to eq(0)
    end

    it 'debits metals if available' do
      expect(squad.debit(1500, 'metals')).to_not be(true)
      squad.debit(1000, 'metals')
      expect(squad.metals).to eq(0)
    end
  end
end
