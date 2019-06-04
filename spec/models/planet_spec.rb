require 'rails_helper'

RSpec.describe Planet, type: :model do
  let(:planet) { build(:planet) }

  it { is_expected.to have_many :fleets }

  it 'has its attributes' do
    expect(planet).to be_an_instance_of(Planet)
    expect(planet.name).to be_a(String)
    expect(planet.sector).to be_a(Integer)
    expect(planet.population).to be_an(Integer)
    expect(planet.credits).to be_an(Integer)
    expect(planet.metals).to be_an(Integer)
    expect(planet.rare_elements).to be_an(Integer)
    expect(planet.domination).to be_a(Hash)
  end

  it 'retrieves serialized domination data' do
    planet.domination = { 1 => 40, 2 => 60 }
    planet.save
    expect(planet.domination).to include { '2 => 60' }
    first_squad_presence = planet.domination[1]
    expect(first_squad_presence).to eq(40)
    second_squad_presence = planet.domination[2]
    expect(second_squad_presence).to_not eq(40)
  end

  it 'has an image' do
    expect(planet.image).to eq("planets/#{planet.name.downcase}.png")
  end

  it 'check if has enemy squads' do
    @squad_a = create(:squad)
    @squad_b = create(:squad)
    @fleet_a = create(:fleet, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, squad: @squad_b)
    expect(planet.under_attack?).to_not be true
    @fleet_b.update(planet: planet)
    expect(planet.under_attack?).to be true    
  end
end
