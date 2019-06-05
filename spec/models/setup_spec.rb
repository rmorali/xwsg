require 'rails_helper'

RSpec.describe Setup, type: :model do
  let(:setup) { build(:setup) }

  it 'has its attributes' do
    expect(setup).to be_an_instance_of(Setup)
    expect(setup.planet_income_ratio).to be_a(Integer)
    expect(setup.initial_credits).to be_a(Integer)
    expect(setup.initial_metals).to be_a(Integer)
    expect(setup.initial_planets).to be_a(Integer)
    expect(setup.initial_wormholes).to be_a(Integer)
    expect(setup.minimum_fleet_for_dominate).to be_a(Integer)
    expect(setup.minimum_fleet_for_build).to be_a(Integer)
    expect(setup.builder_unit).to be_a(String)
    expect(setup.ai).to be_truthy
    expect(setup.ai_level).to be_a(Integer)
  end

  before do
  end

end
