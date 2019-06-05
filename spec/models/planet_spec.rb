require 'rails_helper'

RSpec.describe Planet, type: :model do
  let(:planet) { build(:planet) }

  it { is_expected.to have_many :fleets }
  it { is_expected.to have_many :results }

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

  context '.seen_by squad' do
    before do
      @squad = create(:squad)
      @fleet = create(:fleet, planet: planet, squad: @squad)
    end
    it 'finds planets where squad has fleets' do
      expect(Planet.seen_by(@squad)).to include(planet)
    end
    it 'not includes planets where squad hasnt fleets' do
      not_seen = create(:planet)
      expect(Planet.seen_by(@squad)).to_not include(not_seen)
    end
    it 'shows only one instance of planet' do
      create(:fleet, planet: planet, squad: @squad)
      planets = Planet.seen_by(@squad)
      expect(planets).to eq(planets.uniq)
    end
  end

  context '.result_seen_by squad' do
    before do
      @squad_a = create(:squad)
      @squad_b = create(:squad)
      @fleet_a = create(:fleet, squad: @squad_a, planet: planet)
      @fleet_b = create(:fleet, squad: @squad_b, planet: planet)
      @round = Round.current
      CreateResult.new.create!
    end
    it 'finds planets where squad had results' do
      expect(Planet.fog_seen_by(@squad_a)).to include(planet)
    end
    it 'not includes planets where squad hasnt results' do
      not_seen = create(:planet)
      expect(Planet.fog_seen_by(@squad_a)).to_not include(not_seen)
    end
    it 'shows only one instance of planet' do
      create(:result, planet: planet, squad: @squad_a)
      planets = Planet.fog_seen_by(@squad_a)
      expect(planets).to eq(planets.uniq)
    end
    it 'shows enemy fleets seen by squad' do
      expect(planet.fog_seen_by(@squad_a)).to_not be_empty
      expect(planet.fog_seen_by(@squad_a)).to include(@fleet_b.results.first)
    end
    it 'shows only enemy fleets seen by squad' do
      expect(planet.fog_seen_by(@squad_a)).to_not include(@fleet_a.results.first)
    end
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
