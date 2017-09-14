require 'rails_helper'

RSpec.describe BuildFacility, type: :service do
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }
  let(:unit) { create(:unit) }

  context 'restrictions to build a facility' do
    before do
      faction.save!
      unit.factions = ["Empire"]
      unit.type = 'Facility'
      unit.save
    end

    it 'must be a facility' do
      unit.update_attributes(type: 'Fighter')
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      unit.update_attributes(type: 'Facility')
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

    it 'must belongs to squad faction' do
      unit.factions = ['Mercenary']
      unit.save
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      unit.factions = ['Empire']
      unit.save
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

    it 'squad must have enough credits' do
      squad.update_attributes(credits: 0)
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      squad.update_attributes(credits: 1000)
      BuildFacility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

  end

  context 'building' do
    before do
      faction.save!
      unit.factions = ["Empire"]
      unit.type = 'Facility'
      unit.producing_time = 2
      unit.save
    end

    it 'takes producing time to be built' do
      expect(planet.fleets).to be_empty
      BuildFacility.new(unit,squad,planet).build!
      expect(planet.fleets).to_not be_empty
      expect(planet.fleets.first.in_production?).to be true
      create(:round)
      expect(planet.fleets.first.in_production?).to be true
      create(:round)
      expect(planet.fleets.first.in_production?).to be false
    end

    it 'builds it in a specific planet' do
      expect(planet.fleets).to be_empty
      BuildFacility.new(unit,squad,planet).build!
      expect(planet.fleets).to_not be_empty
    end

  end

end
