require 'rails_helper'

RSpec.describe AiFleet, type: :service do
  let(:faction) { create(:faction) }
  let(:planet_a) { create(:planet, credits: 100) }
  let(:planet_b) { create(:planet, credits: 100) }
  let(:planet_c) { create(:planet, credits: 500) } # Planeta mais rico
  
  before do
    # Configuração de Ambiente e Mock de Round
    @round = create(:round)
    allow(@round).to receive(:number).and_return(2)
    allow(Round).to receive(:current).and_return(@round)
    
    # Configuração de Setup (Saldo inicial para cálculo de % de construção)
    @setup = create(:setup, initial_credits: 5000)
    allow(Setup).to receive(:current).and_return(@setup)

    create(:route, vector_a: planet_a, vector_b: planet_b)
    create(:route, vector_a: planet_a, vector_b: planet_c)
    
    @ai_squad = create(:squad, faction: faction, ai: true, ai_level: 4, credits: 5000)
    
    # Catálogo de Unidades (Persistido no DB para a IA encontrar)
    @fighter = create(:unit, type: 'Fighter', credits: 100)
    @capital = create(:unit, type: 'CapitalShip', credits: 600)
    @transport = create(:unit, type: 'LightTransport', credits: 300)
    @facility = create(:unit, type: 'Facility', credits: 1200)
    @armament = create(:unit, type: 'Armament', credits: 50)

    [@fighter, @capital, @transport, @facility, @armament].each do |u|
      u.update(factions: [faction.name])
    end
  end

  context 'Doutrina de Construção (build!)' do
    it 'constrói a Facility no planeta mais rico e seguro' do
      # Planet A tem a IA, Planet B é vizinho pobre, Planet C é vizinho rico
      # IA precisa ver os planetas
      @ai_squad.update(credits: 2000)
      
      ai = AiFleet.new(@ai_squad)
      ai.act!

      # Deve ter criado uma Facility no Planet C (mais rico)
      facility_fleet = Fleet.joins(:unit).find_by(units: { type: 'Facility' }, planet: planet_c)
      expect(facility_fleet).to_not be_nil
    end

    it 'não constrói Facility se o saldo for inferior a 30% do inicial' do
      @ai_squad.update(credits: 500) # Abaixo de 30% de 2000
      ai = AiFleet.new(@ai_squad)
      
      expect { ai.act! }.to_not change { Fleet.joins(:unit).where(units: { type: 'Facility' }).count }
    end
  end

  context 'Doutrina de Produção (produce!)' do
    before do
      @base = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, round: @round)
    end

    it 'prioriza Fighters se houver menos de 2 no planeta' do
      @ai_squad.update(credits: 1000)
      # Planeta tem 0 fighters e 1 Facility
      
      AiFleet.new(@ai_squad).act!
      
      # Deve ter gasto em Fighters primeiro
      fighters = Fleet.joins(:unit).where(planet: planet_a, units: { type: 'Fighter' })
      expect(fighters.sum(:quantity)).to be >= 1
    end
  end

  context 'Doutrina de Movimentação (TaskForces)' do
    before do
      @ai_squad.update(ai_level: 6) # Máxima agressividade para garantir movimento no teste
      allow_any_instance_of(AiFleet).to receive(:rand).and_return(1) # Força sucesso em rolagens
    end

    it 'move Capital Ship apenas se houver Fighter para escolta no grupo' do
      capital = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      fighter = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 5, round: @round)
      
      AiFleet.new(@ai_squad).act!
      
      expect(capital.reload.destination).to_not be_nil
      expect(fighter.reload.destination).to_not be_nil
    end

    it 'move Capital Ship sozinha se ela tiver Fighters embarcados (Cargo)' do
      capital = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      # Fighter está DENTRO da Capital Ship
      fighter = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 5, round: @round, carrier: capital)
      
      AiFleet.new(@ai_squad).act!
      
      expect(capital.reload.destination).to_not be_nil
    end

    it 'não move Capital Ship se ela estiver totalmente solitária e sem carga' do
      capital = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, round: @round)
      
      AiFleet.new(@ai_squad).act!
      
      expect(capital.reload.destination).to be_nil
    end

    it 'mantém uma guarnição mínima no planeta se houver múltiplas frotas' do
      f1 = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 1, round: @round)
      f2 = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 10, round: @round)
      f3 = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 20, round: @round)

      AiFleet.new(@ai_squad).act!

      # Uma das frotas (a menor, f1) deve ter ficado para trás como guarnição
      destinations = [f1.reload.destination, f2.reload.destination, f3.reload.destination]
      expect(destinations).to include(nil) # Guarnição
      expect(destinations.compact.count).to be >= 2 # Viajantes
    end
  end

  context 'Doutrina de Armamento (arm!)' do
    it 'equipa naves de acordo com o nível de inteligência' do
      @ai_squad.update(ai_level: 6) # Inteligência máxima
      @transport.update(armable: true) # Habilita no catálogo
      fleet = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @transport, quantity: 1, round: @round)
      
      # Força o rand para passar no teste de armamento
      allow_any_instance_of(AiFleet).to receive(:rand).and_return(1)

      AiFleet.new(@ai_squad).act!
      
      expect(fleet.reload.armament).to_not be_nil
    end
  end
end