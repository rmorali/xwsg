require 'rails_helper'

RSpec.describe ProduceUnit, type: :service do
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }
  let(:unit) { create(:unit) }
  let(:fleet) { create(:fleet) }

  context 'restrictions to produce an unit' do
    before do
      shipyard = create(:unit, name: 'Shipyard', type: 'Facility', producing_time: 1)
      @shipyard = create(:fleet, unit: shipyard)
    end
    it 'must be a facility' do
      expect(ProduceUnit.new(@shipyard,unit).facility?).to be true
    end
    it 'cannot be in construction' do
      create(:round)
      expect(ProduceUnit.new(@shipyard,unit).in_production?).to_not be true
    end
    it 'must have enough credits(or metals)' do
      expect(ProduceUnit.new(@shipyard,unit).credits?).to be true
    end

  end

  context 'producing' do
    before do
      shipyard = create(:unit, name: 'Shipyard', type: 'Facility', producing_time: 1)
      @shipyard = create(:fleet, unit: shipyard)
      create(:round)
      ProduceUnit.new(@shipyard,unit).produce!
    end
    it 'debits squad credits(or metals)' do
    #TODO debits squad credits/metals to produce multiple units or only one unit by its producing time?
    end
    it 'starts to produce an unit' do
      expect(Fleet.last.unit).to eq(unit)
    end
    it 'keeps the producing unit within the facility' do
      expect(Fleet.last.carrier).to eq(@shipyard)
    end

  end

end
