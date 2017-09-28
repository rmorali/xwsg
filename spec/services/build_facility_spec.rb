require 'rails_helper'

RSpec.describe BuildFacility, type: :service do
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }
  let(:unit) { create(:unit) }

  context 'building a facility' do
    before do
      faction.save!
      @squad = create(:squad, credits: 1000, metals: 1000, faction: faction)
      @shipyard = create(:unit, type: 'Facility', producing_time: 2, credits: 900, metals: 900)
    end
    it 'squad must have enough resources' do
      @squad.update(credits: 0)
      BuildFacility.new(@shipyard, @squad, planet).build!
      expect(Fleet.all).to be_empty
      @squad.update(credits: 1000)
      BuildFacility.new(@shipyard, @squad, planet).build!
      expect(Fleet.all).to_not be_empty
    end

    it 'debits squad resources' do
      BuildFacility.new(@shipyard, @squad, planet).build!
      expect(@squad.credits).to eq(100)
      expect(@squad.metals).to eq(100)
    end

    it 'takes time to be built' do
      expect(planet.fleets).to be_empty
      BuildFacility.new(@shipyard, @squad, planet).build!
      expect(planet.fleets).to_not be_empty
#TODO we only can check this when rounds logics be implemented
      #expect(planet.fleets.first.in_production?).to be true
      #create(:round)
      #expect(planet.fleets.first.in_production?).to be true
      #create(:round)
      #expect(planet.fleets.first.in_production?).to be false
    end

    it 'builds it in a specific planet' do
      expect(planet.fleets).to be_empty
      BuildFacility.new(@shipyard, @squad, planet).build!
      expect(planet.fleets).to_not be_empty
    end
  end
end
