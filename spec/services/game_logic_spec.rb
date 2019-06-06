require 'rails_helper'

RSpec.describe GameLogic, type: :service do
  let(:unit) { create(:unit) }
  let(:setup) { create(:setup) }
  let(:faction) { create(:faction) }
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
      expect(@round.phase).to eq(0)
      @rebel.ready!
      GameLogic.new.check_state!
      expect(@round.reload.phase).to eq(1)
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
      5.times { create(:planet) }
    end

    it 'sets initial credits for squads' do
      game = GameLogic.new
      game.set_initial(@empire)
      expect(@empire.reload.credits).to eq(2400)
      expect(@empire.reload.metals.to_i).to eq(2400)
    end

    it 'populates random planets for squads' do
      GameLogic.new.new_game!
      expect(@empire.fleets).to_not be_empty
    end

    it 'debits squads credits to populate planets' do
      expect(@empire.reload.credits).to eq(0)
    end
  end

  context 'strategy phase' do
  end

  context 'space combat phase' do
    it 'updates fleets and facilities producing situation' do
    end
    it 'complete producing fleets and facilities' do
    end
  end
end
