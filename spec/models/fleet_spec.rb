require 'rails_helper'

RSpec.describe Fleet, type: :model do

  let(:fleet) { create(:fleet) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }

  context 'scopes' do
    before do
      fleet.unit.producing_time = 1
      fleet.unit.terrain = 'Space'
      fleet.unit.save
      fleet.round = Round.get_current
      fleet.save
    end
    it 'finds full built units' do
      expect(Fleet.operational).to_not include(fleet)
      Round.create
      expect(Fleet.operational).to include(fleet)
    end
    it 'finds units from specific terrain' do
      expect(Fleet.terrain('Ground')).to_not include(fleet)
      expect(Fleet.terrain('Space')).to include(fleet)
    end
    it 'finds enemies fleets' do
      enemy = create(:squad)
      create(:fleet, squad: enemy)
      expect(Fleet.enemy_of(fleet.squad)).to_not include(fleet)
      expect(Fleet.enemy_of(enemy)).to include(fleet)
    end

  end

end
