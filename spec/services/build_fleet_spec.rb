require 'rails_helper'

RSpec.describe BuildFleet, type: :service do
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }
  let(:unit) { create(:unit) }
  let(:fleet) { create(:fleet) }

  context 'building fleets' do
    before do
      faction.save!
      @squad = create(:squad, credits: 100, faction: faction)
      shipyard = create(:unit, name: 'Shipyard', type: 'Facility', producing_time: 1)
      @shipyard = create(:fleet, squad: @squad, unit: shipyard)
      @tie_fighter = create(:unit, credits: 0, producing_time: 1)
      @escort_carrier = create(:unit, credits: 500, producing_time: 1)
      create(:round)
    end

    it 'squad must have enough resources' do
      expect(BuildFleet.new(1, @tie_fighter, @squad, planet).valid?).to be true
      expect(BuildFleet.new(1, @escort_carrier, @squad, planet).valid?).to_not be true
      @squad.update(credits: 1000)
      expect(BuildFleet.new(1, @escort_carrier, @squad, planet).valid?).to be true
    end

    it 'debits squad resources' do
      BuildFleet.new(1, @tie_fighter, @squad, planet).build!
      expect(@squad.credits).to eq(100)
    end

    it 'starts to produce an unit' do
      BuildFleet.new(1, @tie_fighter, @squad, planet).build!
      expect(Fleet.last.unit).to eq(@tie_fighter)
    end

    it 'takes time to be produced' do
      round = create(:round)
      BuildFleet.new(1, @tie_fighter, @squad, planet).build!
      expect(Fleet.last.in_production?).to eq(true)
      GameLogic.new.space_combat!
      expect(Fleet.last.in_production?).to eq(false)
    end

    it 'keeps the producing unit in the facility' do
      BuildFleet.new(1, @tie_fighter, @squad, planet, @shipyard).build!
      expect(@shipyard.cargo).to include(Fleet.last)
    end
  end
end
