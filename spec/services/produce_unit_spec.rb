require 'rails_helper'

RSpec.describe ProduceUnit, type: :service do
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }
  let(:unit) { create(:unit) }
  let(:fleet) { create(:fleet) }

  context 'producing units' do
    before do
      faction.save!
      @squad = create(:squad, metals: 100, faction: faction)
      shipyard = create(:unit, name: 'Shipyard', type: 'Facility', producing_time: 1)
      @shipyard = create(:fleet, squad: @squad, unit: shipyard)
      @tie_fighter = create(:unit, metals: 10, producing_time: 1)
      create(:round)
    end
    it 'factory must be a facility' do
      expect(ProduceUnit.new(@shipyard,@tie_fighter).facility?).to be true
    end
    it 'facility cant be in construction' do
      expect(ProduceUnit.new(@shipyard,@tie_fighter).in_production?).to_not be true
    end
    it 'squad must have enough metals' do
      @squad.update_attributes(metals: 0)
      expect(ProduceUnit.new(@shipyard,@tie_fighter).metals?).to_not be true
      @squad.update_attributes(metals: 1000)
      expect(ProduceUnit.new(@shipyard,@tie_fighter).metals?).to be true
    end

    it 'debits squad metals' do
      ProduceUnit.new(@shipyard,@tie_fighter).produce!
      expect(@squad.metals).to eq(90)
    end
    it 'takes time to be produced' do
      ProduceUnit.new(@shipyard,@tie_fighter).produce!
      expect(Fleet.last.in_production?).to eq(true)
      create(:round)
      expect(Fleet.last.in_production?).to_not eq(true)
    end
    it 'starts to produce an unit' do
      ProduceUnit.new(@shipyard,@tie_fighter).produce!
      expect(Fleet.last.unit).to eq(@tie_fighter)
    end
    it 'keeps the producing unit within the facility' do
      ProduceUnit.new(@shipyard,@tie_fighter).produce!
      expect(Fleet.last.carrier).to eq(@shipyard)
    end

  end

end
