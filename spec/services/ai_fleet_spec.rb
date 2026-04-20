require 'rails_helper'

RSpec.describe AiFleet, type: :service do
  let(:faction) { create(:faction) }
  let(:planet_a) { create(:planet) }
  let(:planet_b) { create(:planet) }
  
  before do
    # 1. Criamos o round sem tentar forçar a coluna number que não existe no DB
    @round = create(:round)
    
    # 2. "Enganamos" a IA dizendo que este é o Round 2 e é o round atual
    allow(@round).to receive(:number).and_return(2)
    allow(Round).to receive(:current).and_return(@round)
    
    create(:route, vector_a: planet_a, vector_b: planet_b)
    
    @ai_squad = create(:squad, faction: faction, ai: true, ai_level: 4, credits: 2000)
    @human_squad = create(:squad, faction: faction, ai: false)

    @fighter_1 = create(:unit, type: 'Fighter', credits: 100)
    @fighter_2 = create(:unit, type: 'Fighter', credits: 150)
    @capital   = create(:unit, type: 'CapitalShip', credits: 600)
    @facility  = create(:unit, type: 'Facility', credits: 1200)

    # Salvamos no DB para a IA conseguir encontrar na hora de comprar
    @fighter_1.update(factions: [faction.name])
    @fighter_2.update(factions: [faction.name])
    @capital.update(factions: [faction.name])
    @facility.update(factions: [faction.name])
  end

  context 'validação básica' do
    it 'ignora o turno se o esquadrão não for controlado por IA' do
      ai = AiFleet.new(@human_squad)
      expect(ai).to_not receive(:produce!)
      ai.act!
      expect(@human_squad.reload.ready?).to be false
    end

    it 'marca o esquadrão como pronto ao final do turno' do
      ai = AiFleet.new(@ai_squad)
      ai.act!
      expect(@ai_squad.reload.ready?).to be true
    end
  end

  context 'produção inteligente (smartness >= 3)' do
    before do
      @base = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, round: @round)
      @ai_squad.update(credits: 1000) 
    end

    it 'compra caças de escolta primeiro se tiver naves capitais desprotegidas' do
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      
      ai = AiFleet.new(@ai_squad)
      
      expect { ai.act! }.to change { Fleet.joins(:unit).where(units: { type: 'Fighter' }).count }.by_at_least(1)
      expect(Fleet.joins(:unit).where(units: { type: 'CapitalShip' }).sum(:quantity)).to eq(1) 
    end
  end

  context 'movimentação de Força Tarefa' do
    before do
      @ai_squad.update(ai_level: 5)
      @ai = AiFleet.new(@ai_squad)
      
      allow(@ai).to receive(:planet_in_danger?).and_return(true) 
    end

    it 'move a força tarefa inteira para o mesmo destino' do
      fleet_1 = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter_1, quantity: 5, round: @round)
      fleet_2 = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter_2, quantity: 5, round: @round)

      @ai.act!

      expect(fleet_1.reload.destination).to eq(planet_b)
      expect(fleet_2.reload.destination).to eq(planet_b)
    end

    it 'aborta o movimento de Capital Ships se não tiverem escolta suficiente' do
      capital_fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      fighter_fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter_1, quantity: 1, round: @round)

      @ai.act!

      expect(capital_fleet.reload.destination).to be_nil
      expect(fighter_fleet.reload.destination).to eq(planet_b)
    end

    it 'autoriza o movimento da Capital Ship se ela tiver escolta forte' do
      capital_fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      fighter_fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter_1, quantity: 3, round: @round)

      @ai.act!

      expect(capital_fleet.reload.destination).to eq(planet_b)
      expect(fighter_fleet.reload.destination).to eq(planet_b)
    end
  end

  context 'escolha de destino e perigo' do
    it 'escolhe o planeta inimigo mais fraco (smartness alta)' do
      create(:fleet, squad: @human_squad, planet: planet_b, unit: @fighter_1, quantity: 20, round: @round)
      
      planet_c = create(:planet)
      create(:route, vector_a: planet_a, vector_b: planet_c)
      create(:fleet, squad: @human_squad, planet: planet_c, unit: @fighter_1, quantity: 5, round: @round)

      fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter_1, quantity: 10, round: @round)

      @ai_squad.update(ai_level: 5)
      ai = AiFleet.new(@ai_squad)
      allow(ai).to receive(:planet_in_danger?).and_return(true)

      ai.act!

      expect(fleet.reload.destination).to eq(planet_c)
    end
  end
end