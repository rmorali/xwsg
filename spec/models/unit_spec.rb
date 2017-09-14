require 'rails_helper'

RSpec.describe Unit, type: :model do

  let(:unit) { create(:unit) }
  let(:faction) { create(:faction) }
  let(:squad) { create(:squad) }

  it { is_expected.to have_many :fleets }

  it 'has its attributes' do
    expect(unit).to be_an_instance_of(Unit)
    expect(unit.name).to be_a(String)
    expect(unit.acronym).to be_a(String)
    expect(unit.type).to be_a(String)
    expect(unit.terrain).to be_a(String)
    expect(unit.hyperdrive).to be_an(Integer)
    expect(unit.credits).to be_an(Integer)
    expect(unit.metals).to be_an(Integer)
    expect(unit.rare_elements).to be_an(Integer)
    expect(unit.producing_time).to be_an(Integer)
    expect(unit.load_weigth).to be_an(Integer)
    expect(unit.load_capacity).to be_an(Integer)
    expect(unit.groupable).to be_truthy
  end

  it 'has an image' do
    expect(unit.image).to eq("units/#{unit.name.downcase}.png")
  end

  context 'belongings' do
    before do
      @empire = create(:faction, name: 'Empire')
      @rebel = create(:faction, name: 'Rebel')
      @mercenary = create(:faction, name: 'Mercenary')
    end

    it 'calculate bitmask correctly' do
      unit.factions = ['Empire', 'Mercenary']
      expect(Unit.allowed_for('Mercenary')).to_not be_empty
    end

    it 'has a faction' do
      unit.factions = ['Empire']
      expect(unit.factions).to include 'Empire'
    end

    it 'has multiple factions' do
      unit.factions = ['Empire', 'Rebel']
      expect(unit.factions).to contain_exactly('Empire','Rebel')
      expect(unit.factions).to_not include('Mercenary')
    end

    it 'belongs to a squad' do
      unit.factions = ['Empire', 'Rebel']
      faction.name = 'Empire'
      faction.save
      squad.faction = faction
      squad.save
      expect(unit.belongs?(squad.faction)).to be true
    end

  end

end
