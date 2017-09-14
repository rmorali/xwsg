require 'rails_helper'

RSpec.describe Facility, type: :service do
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
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      unit.update_attributes(type: 'Facility')
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

    it 'must be of squad faction' do
      unit.factions = ['Mercenary']
      unit.save
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      unit.factions = ['Empire']
      unit.save
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

    it 'squad must have enough credits' do
      squad.update_attributes(credits: 0)
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to be_empty
      squad.update_attributes(credits: 1000)
      Facility.new(unit,squad,planet).build!
      expect(Fleet.all).to_not be_empty
    end

  end

  context 'building' do

    it 'builds it in a specific planet' do

    end

    it 'takes rounds to be built' do

    end

  end

end
