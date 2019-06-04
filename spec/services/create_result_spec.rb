require 'rails_helper'

RSpec.describe CreateResult, type: :service do
  let(:planet) { create(:planet) }

  before do
    @squad_a = create(:squad)
    @squad_b = create(:squad)
    @fleet_a = create(:fleet, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, squad: @squad_b, planet: planet)
  end
  it 'creates results table for planets in attack' do
    CreateResult.new.create!
    expect(Result.count).to be > 1
  end
end
