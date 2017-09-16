require 'rails_helper'

RSpec.describe Fleet, type: :model do

  let(:fleet) { create(:fleet) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }
  it { is_expected.to belong_to :carrier }
  it { is_expected.to belong_to :destination}

  context 'scopes' do
    before do
      fleet.unit.producing_time = 1
      fleet.unit.terrain = 'Space'
      fleet.unit.save
      fleet.round = Round.get_current
      fleet.save
    end
    it 'finds units in production' do
      expect(Fleet.in_production).to include(fleet)
      Round.create
      expect(Fleet.in_production).to_not include(fleet)
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

  context 'carriers and cargoes' do
    before do
      @cargo1 = create(:fleet)
      @cargo2 = create(:fleet)
    end

    it 'load fleets in a carrier' do
      @cargo1.carrier = fleet
      @cargo1.save
      @cargo2.carrier = fleet
      @cargo2.save
      expect(@cargo1.carrier).to be fleet
      expect(fleet.cargo).to include(@cargo1)
      expect(fleet.cargo).to include(@cargo2)
    end

  end

end
