require 'rails_helper'

RSpec.describe Setup, type: :model do
  let(:setup) { create(:setup) }

  it 'has its attributes' do
    expect(setup).to be_an_instance_of(Setup)
    expect(setup.planet_income_ratio).to be_a(Integer)
    expect(setup.initial_credits).to be_a(Integer)
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

  it 'returns game settings' do
    setup = Setup.new
    setup.save
    expect(Setup.current).to_not be_nil
  end

end
