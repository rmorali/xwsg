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
      @squad = create(:squad, credits: 100, metals: 1000, faction: faction)
      shipyard = create(:unit, name: 'Shipyard', type: 'Facility', producing_time: 1)
      @shipyard = create(:fleet, squad: @squad, unit: shipyard)
      @tie_fighter = create(:unit, credits: 0, metals: 10, producing_time: 1)
      @escort_carrier = create(:unit, credits: 500, metals: 500, producing_time: 1)
      create(:round)
    end

    it 'facility cant be in construction' do
      #TODO we only can check this when rounds logics be implemented
      #expect(ProduceUnit.new(@shipyard, @tie_fighter).in_production?).to_not be true
    end

    it 'squad must have enough resources' do
      expect(ProduceUnit.new(@shipyard, @tie_fighter).valid?).to be true
      expect(ProduceUnit.new(@shipyard, @escort_carrier).valid?).to_not be true
      @squad.update(credits: 1000, metals: 1000)
      expect(ProduceUnit.new(@shipyard, @escort_carrier).valid?).to be true
    end

    it 'debits squad resources' do
      ProduceUnit.new(@shipyard, @tie_fighter).produce!
      expect(@squad.metals).to eq(990)
      expect(@squad.credits).to eq(100)
    end

    it 'starts to produce an unit' do
      ProduceUnit.new(@shipyard, @tie_fighter).produce!
      expect(Fleet.last.unit).to eq(@tie_fighter)
    end

    it 'takes time to be produced' do
      ProduceUnit.new(@shipyard, @tie_fighter).produce!
      #TODO we only can check this when rounds logics be implemented
      #expect(Fleet.last.in_production?).to eq(true)
      #create(:round)
      #expect(Fleet.last.in_production?).to_not eq(true)
    end

    it 'keeps the producing unit in the facility' do
      ProduceUnit.new(@shipyard, @tie_fighter).produce!
      expect(@shipyard.cargo).to include(Fleet.last)
    end
  end
end
