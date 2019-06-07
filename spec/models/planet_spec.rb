require 'rails_helper'

RSpec.describe Planet, type: :model do
  let(:planet) { build(:planet) }
  let(:setup) { create(:setup) }

  it { is_expected.to have_many :fleets }
  it { is_expected.to have_many :results }

  it 'has its attributes' do
    expect(planet).to be_an_instance_of(Planet)
    expect(planet.name).to be_a(String)
    expect(planet.sector).to be_a(Integer)
    expect(planet.population).to be_an(Integer)
    expect(planet.credits).to be_an(Integer)
    expect(planet.domination).to be_a(Hash)
  end

  before do
    @squad_a = create(:squad)
    @squad_b = create(:squad)
    @fleet_a = create(:fleet, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, squad: @squad_b, planet: planet)
  end

  context '.fleets_seen by squad' do
    it 'finds planets where squad has fleets' do
      expect(Planet.seen_by(@squad_a)).to include(planet)
    end
    it 'not includes planets where squad hasnt fleets' do
      not_seen = create(:planet)
      expect(Planet.seen_by(@squad_a)).to_not include(not_seen)
    end
    it 'shows only one instance of planet' do
      create(:fleet, planet: planet, squad: @squad_a)
      planets = Planet.seen_by(@squad_a)
      expect(planets).to eq(planets.uniq)
    end
    it 'shows only squad fleets' do
      @fleet_a2 = create(:fleet, squad: @squad_a, planet: planet)
      expect(planet.fleets_seen_by(@squad_a)).to_not be_empty
      expect(planet.fleets_seen_by(@squad_a)).to include(@fleet_a)
      expect(planet.fleets_seen_by(@squad_a)).to include(@fleet_a2)
      expect(planet.fleets_seen_by(@squad_a)).to_not include(@fleet_b)
    end
    it 'Show enemy fleets produced before current round if squad has a radar' do
      #TODO: radar
    end
  end

  context '.fog_seen_by squad' do
    before do
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

  it 'returns present squads' do
    expect(planet.squads).to include(@squad_a)
    expect(planet.squads).to include(@squad_b)
  end

  it 'check if has enemy squads' do
    expect(planet.under_attack?).to be true
    @fleet_b.update(planet: create(:planet))
    expect(planet.under_attack?).to_not be true
  end

  it 'returns fleet presence' do
    expect(planet.fleets_presence).to include([@squad_a, @fleet_a.credits])
    expect(planet.fleets_presence).to include([@squad_b, @fleet_b.credits])
  end

  it 'returns an empty random planet' do
    planet_a = create(:planet)
    planet_b = create(:planet)
    random_planet = Planet.random
    expect(random_planet).to eq(random_planet)
    #TODO: Achar um jeito de testar random
  end

  it 'returns its total income' do
    @setup = setup
    expect(planet.income).to eq(planet.credits * @setup.planet_income_ratio)
  end

end
