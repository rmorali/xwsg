require 'rails_helper'

RSpec.describe SetLevel, type: :service do
  let(:planet) { build(:planet) }
  let(:setup) { create(:setup) }
  before(:each) do
    @setup = setup
    @squad_a = build(:squad)
    @squad_b = build(:squad)
    @fleet_a = create(:fleet, quantity: 10, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, quantity: 10, squad: @squad_b, planet: planet)
    CreateResult.new.create!
  end
  it 'upgrade level in combats' do
    expect(@fleet_a.reload.level).to eq(1)
  end
  it 'upgrade 3 levels if paid' do
    SetLevel.new(@fleet_a).upgrade!
    expect(@fleet_a.reload.level).to eq(3)
  end
end
