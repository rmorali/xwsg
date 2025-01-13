require 'rails_helper'

RSpec.describe GameLogic, type: :service do
  let(:unit) { create(:unit) }
  let(:setup) { create(:setup) }
  let(:faction) { create(:faction) }
  let(:planet) { create(:planet) }
  before do
    Faction.create([
                     { name: 'Empire' },
                     { name: 'Rebel' },
                     { name: 'Mercenary' }
                   ])
    @empire = create(:squad, faction: Faction.first)
    @rebel = create(:squad, faction: Faction.second)
    @round = Round.current
  end

  context 'all squads ready' do
    before do
      @empire.ready!
    end
    it 'starts another phase' do
      GameLogic.new.check_state!
      expect(@round.strategy?).to be true
      @rebel.ready!
      GameLogic.new.check_state!
      expect(@round.reload.space_combat?).to be true
    end
    it 'turns back their states' do
      @rebel.ready!
      GameLogic.new.check_state!
      expect(@rebel.reload.ready?).to_not eq(true)
      expect(@empire.reload.ready?).to_not eq(true)
    end
  end

  context 'check phases' do
    it 'executes logics accordingly to the round phase' do
    end
  end

  context 'new game' do
    before do
      @setup = setup
      all = %w[Empire Rebel Mercenary]
      @facility = create(:unit, type: 'Facility', credits: 1200 ).factions = all
      @capital_ship = create(:unit, type: 'CapitalShip', credits: 600 ).factions = all
      @fighter = create(:unit, type: 'Fighter', credits: 100 ).factions = all
      5.times { create(:planet, credits: 0) }
    end

    it 'sets initial credits for squads' do
      game = GameLogic.new
      game.set_initial(@empire)
      expect(@empire.reload.credits).to eq(12000)
    end

    it 'sets income for planets' do
      expect(Planet.first.credits).to eq(0)
      GameLogic.new.new_game!
      expect(Planet.first.credits).to eq(100)
    end

    it 'populates random planets for squads' do
      GameLogic.new().new_game!
      expect(@empire.reload.fleets).to_not be_empty
      expect(@empire.reload.fleets.any? { |fleet| fleet.type == 'Facility' }).to be true
      expect(@empire.reload.fleets.any? { |fleet| fleet.type == 'CapitalShip' }).to be true
      expect(@empire.reload.fleets.any? { |fleet| fleet.type == 'Fighter' }).to be true
    end

    it 'debits squads credits to populate planets' do
      expect(@empire.reload.credits).to be < 2400
    end
  end

  context 'strategy phase' do
  end

  context 'space combat phase' do
    before do
      @squad_a = create(:squad)
      @squad_b = create(:squad)
      @fleet_a = create(:fleet, squad: @squad_a, planet: planet)
      @fleet_b = create(:fleet, squad: @squad_b, planet: planet)
    end
    it 'creates result table for combats' do
      expect(Result.all.count).to eq(0)
      GameLogic.new.space_combat!
      expect(Result.all.count).to be > 0
    end

    it 'updates fleets and facilities producing situation' do
    end
    it 'complete producing fleets and facilities' do
    end
  end
end
