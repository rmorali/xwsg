require 'rails_helper'

RSpec.describe Unit, type: :model do

  let(:unit) { build(:unit) }
  
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
  
    it 'calculate bitmask correctly' do
      unit.factions = ['mercenary']
      expect(Unit.allowed_for('mercenary')).to_not be_empty
    end
  
    it 'has a faction' do
      unit.factions = 'empire'
      expect(unit.factions).to include 'empire'      
    end
    
    it 'has multiple factions' do
      unit.factions = ['empire','rebel']
      expect(unit.factions).to contain_exactly('empire','rebel')
      expect(unit.factions).to_not include 'mercenary'
    end

  end

end

