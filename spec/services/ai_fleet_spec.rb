require 'rails_helper'

RSpec.describe AiFleet, type: :service do
  let(:faction)  { create(:faction) }
  let(:planet_a) { create(:planet, credits: 100) }
  let(:planet_b) { create(:planet, credits: 100) }
  let(:planet_c) { create(:planet, credits: 500) }

  before do
    @round = create(:round)
    allow(@round).to receive(:number).and_return(2)
    allow(Round).to receive(:current).and_return(@round)

    @setup = create(:setup, initial_credits: 4000)
    allow(Setup).to receive(:current).and_return(@setup)

    create(:route, vector_a: planet_a, vector_b: planet_b)
    create(:route, vector_a: planet_a, vector_b: planet_c)

    @ai_squad    = create(:squad, faction: faction, ai: true, ai_level: 4, credits: 5000)
    @enemy_squad = create(:squad, faction: create(:faction, name: 'Rebel'), ai: false)

    @fighter     = create(:unit, type: 'Fighter', hyperdrive: 1, credits: 100, weight: 2, laser_attack: 20, shield: 50, hull: 50)
    @interceptor = create(:unit, type: 'Interceptor', hyperdrive: 1, credits: 130, weight: 2, laser_attack: 30, shield: 40, hull: 40)
    @bomber      = create(:unit, type: 'Bomber', hyperdrive: 1, credits: 150, weight: 3, ordnance_attack: 40, shield: 60, hull: 60)
    @tie_no_hd   = create(:unit, type: 'Fighter', hyperdrive: 0, credits: 60, weight: 2, laser_attack: 15, shield: 0, hull: 40)
    @capital     = create(:unit, type: 'CapitalShip', hyperdrive: 1, credits: 600, capacity: 12, weight: 20, laser_attack: 80, shield: 500, hull: 500)
    @transport   = create(:unit, type: 'LightTransport', hyperdrive: 1, credits: 300, capacity: 8, weight: 5, armable: true)
    @facility    = create(:unit, type: 'Facility', credits: 1200)
    @armament    = create(:unit, type: 'Armament', credits: 50)

    [@fighter, @interceptor, @bomber, @tie_no_hd, @capital, @transport, @facility, @armament].each do |u|
      u.update!(factions: [faction.name])
    end
  end

  describe 'Produção Proporcional e Expansão (Facilities)' do
    it 'prioriza produção onde há Facility pronta (ready_in: 0 ou nil) mantendo mix de unidades' do
      @ai_squad.update!(credits: 2200)
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      produced = Fleet.joins(:unit).where(squad: @ai_squad, planet: planet_a).where.not(units: { type: 'Facility' })
      expect(produced.sum(:quantity)).to be >= 3
      expect(produced.joins(:unit).where(units: { type: 'Fighter' }).sum(:quantity)).to be >= 2
    end

    it 'constrói no máximo 1 Facility por planeta quando há saldo excedente e guarnição' do
      @ai_squad.update!(credits: 4500)
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 3, ready_in: 0, round: @round)
      create(:fleet, squad: @ai_squad, planet: planet_c, unit: @fighter, quantity: 2, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      facilities = Fleet.joins(:unit).where(squad: @ai_squad, units: { type: 'Facility' })
      expect(facilities.count).to eq(1)
      expect(facilities.first.planet).to eq(planet_c)
    end

    it 'nunca constrói segunda Facility em planeta que já possui uma' do
      @ai_squad.update!(credits: 6000)
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, ready_in: 0, round: @round)
      create(:fleet, squad: @ai_squad, planet: planet_b, unit: @facility, quantity: 1, ready_in: 2, round: @round)
      create(:fleet, squad: @ai_squad, planet: planet_c, unit: @facility, quantity: 1, ready_in: 0, round: @round)

      expect { AiFleet.new(@ai_squad).act! }
        .not_to change { Fleet.joins(:unit).where(squad: @ai_squad, units: { type: 'Facility' }).count }
    end
  end

  describe 'Guarnição Obrigatória (Facilities prontas, em construção e CapitalShips)' do
    before do
      @ai_squad.update!(ai_level: 6)
      allow_any_instance_of(AiFleet).to receive(:rand).and_return(1)
    end

    it 'nunca deixa uma Facility em construção (ready_in > 0) desguarnecida' do
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, ready_in: 2, round: @round)
      only_escort = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @interceptor, quantity: 2, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(only_escort.reload.destination).to be_nil
    end

    it 'nunca deixa uma Facility pronta ou CapitalShip totalmente desguarnecida' do
      create(:fleet, squad: @ai_squad, planet: planet_a, unit: @facility, quantity: 1, ready_in: 0, round: @round)
      only_escort = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @interceptor, quantity: 1, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(only_escort.reload.destination).to be_nil
    end
  end

  describe 'Logística de Embarque e Movimentação no Nível 4' do
    before do
      @ai_squad.update!(ai_level: 4, credits: 0)
      allow_any_instance_of(AiFleet).to receive(:rand).and_return(1)
    end

    it 'embarca Fighters em LightTransport e despacha a Task Force no nível 4' do
      transport = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @transport, quantity: 1, ready_in: 0, round: @round)
      fighters  = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 3, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(Fleet.where(carrier: transport).sum(:quantity)).to eq(3)
      expect(transport.reload.destination).not_to be_nil
    end

    it 'move CapitalShip quando possui Fighters embarcados ou de escolta' do
      capital  = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, ready_in: 0, round: @round)
      fighters = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 4, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(capital.reload.destination).not_to be_nil
    end
  end

  describe 'Inteligência de Vizinhos (Níveis 5 e 6)' do
    before do
      @ai_squad.update!(ai_level: 6, credits: 0)
      allow_any_instance_of(AiFleet).to receive(:rand).and_return(1)
    end

    it 'evita ataque suicida contra planeta vizinho com força inimiga muito superior' do
      create(:fleet, squad: @enemy_squad, planet: planet_b, unit: @capital, quantity: 4, ready_in: 0, round: @round)
      small_patrol = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @interceptor, quantity: 2, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(small_patrol.reload.destination).to be_nil
    end

    it 'ataca o planeta inimigo mais fraco quando possui superioridade de combate' do
      create(:fleet, squad: @enemy_squad, planet: planet_b, unit: @fighter, quantity: 2, ready_in: 0, round: @round)
      create(:fleet, squad: @enemy_squad, planet: planet_c, unit: @capital, quantity: 5, ready_in: 0, round: @round)

      garrison   = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @interceptor, quantity: 1, ready_in: 0, round: @round)
      strike_cap = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @capital, quantity: 1, ready_in: 0, round: @round)
      strike_ftr = create(:fleet, squad: @ai_squad, planet: planet_a, unit: @fighter, quantity: 5, ready_in: 0, round: @round)

      AiFleet.new(@ai_squad).act!

      expect(strike_cap.reload.destination).to eq(planet_b)
    end
  end
end