require 'rails_helper'

RSpec.describe SimulateCombat, type: :service do
let(:planet) { create(:planet) }
  before do
    @squad_a = create(:squad)
    @squad_b = create(:squad)
    @fleet_a = create(:fleet, quantity: 10, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, quantity:10, squad: @squad_b, planet: planet)
    CreateResult.new.create!
  end
  context 'planets in conflict' do
    it 'has 2 squads in the same planet' do
      expect(planet.under_attack?).to be true   
    end
    it 'has results table for the conflict' do
      expect(Result.first.planet).to eq(planet)
    end
  end
end
