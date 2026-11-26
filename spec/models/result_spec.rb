require 'rails_helper'

RSpec.describe Result, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to :round }
    it { is_expected.to belong_to :unit }
    it { is_expected.to belong_to :fleet }
    it { is_expected.to belong_to :squad }
    it { is_expected.to belong_to :planet }
    it { is_expected.to belong_to(:captor).class_name('Squad').optional }
    it { is_expected.to belong_to(:carrier).class_name('Result').optional }
    it { is_expected.to belong_to(:destination).class_name('Planet').optional }
    it { is_expected.to belong_to(:armament).class_name('Unit').optional }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:blasted).allow_nil }
    it { is_expected.to validate_numericality_of(:fled).allow_nil }
    it { is_expected.to validate_numericality_of(:captured).allow_nil }

    it 'requires a captor when captured is greater than zero' do
      result = build(:result, quantity: 10, captured: 2, captor: nil)
      expect(result).not_to be_valid
      expect(result.errors[:captor]).to be_present

      result.captor = create(:squad)
      expect(result).to be_valid
    end

    it 'validates that blasted + fled + captured does not exceed quantity or go negative' do
      captor = create(:squad)
      over_limit = build(:result, quantity: 5, blasted: 3, fled: 2, captured: 1, captor: captor)
      expect(over_limit).not_to be_valid
      expect(over_limit.errors[:blasted]).to include('exceed fleet quantity')

      negative = build(:result, quantity: 5, blasted: -1, fled: 0, captured: 0)
      expect(negative).not_to be_valid

      exact = build(:result, quantity: 5, blasted: 2, fled: 2, captured: 1, captor: captor)
      expect(exact).to be_valid
    end
  end

  describe '#armory?' do
    it 'delegates armory flag from unit' do
      unit_with_armory = create(:unit, armory: true)
      unit_without_armory = create(:unit, armory: false)

      expect(build(:result, unit: unit_with_armory).armory?).to be true
      expect(build(:result, unit: unit_without_armory).armory?).to be false
    end
  end

  describe '#movable?' do
    let(:planet_a) { create(:planet) }
    let(:planet_b) { create(:planet) }
    let(:fleet) { create(:fleet, planet: planet_a) }

    before { create(:route, vector_a: planet_a, vector_b: planet_b, distance: 1) }

    it 'returns true when unit has hyperdrive, is ready and has valid routes' do
      unit = create(:unit, hyperdrive: 1)
      result = create(:result, unit: unit, fleet: fleet, planet: planet_a, ready_in: 0)

      expect(result.movable?).to be true
    end

    it 'returns nil/falsey when without hyperdrive, in production or without routes' do
      no_hd = create(:unit, hyperdrive: 0)
      expect(create(:result, unit: no_hd, fleet: fleet, planet: planet_a, ready_in: 0).movable?).to be_falsey

      hd_unit = create(:unit, hyperdrive: 1)
      expect(create(:result, unit: hd_unit, fleet: fleet, planet: planet_a, ready_in: 2).movable?).to be_falsey

      isolated_planet = create(:planet)
      isolated_fleet = create(:fleet, planet: isolated_planet)
      expect(create(:result, unit: hd_unit, fleet: isolated_fleet, planet: isolated_planet, ready_in: 0).movable?).to be_falsey
    end
  end

  describe '#moving?' do
    it 'returns true only when destination is present' do
      expect(build(:result, destination: nil).moving?).to be_falsey
      expect(build(:result, destination: create(:planet)).moving?).to be true
    end
  end

  describe '#in_production? and #production_status' do
    it 'identifies production state and calculates percentage progress' do
      ready_result = build(:result, ready_in: 0)
      expect(ready_result.in_production?).to be false
      expect(ready_result.production_status).to eq(100.0)

      building_result = build(:result, ready_in: 3)
      expect(building_result.in_production?).to be true
      expect(building_result.production_status).to eq(25.0)
    end
  end

  describe '#builder?' do
    let!(:setup) { create(:setup, builder_unit: 'Trooper', minimum_fleet_for_build: 10) }

    it 'returns true for stationary Facility or Trooper fleet meeting minimum quantity' do
      facility_unit = create(:unit, type: 'Facility')
      expect(build(:result, unit: facility_unit, ready_in: 0, destination: nil).builder?).to be true

      trooper_unit = create(:unit, type: 'Trooper')
      expect(build(:result, unit: trooper_unit, quantity: 10, ready_in: 0, destination: nil).builder?).to be true
      expect(build(:result, unit: trooper_unit, quantity: 9, ready_in: 0, destination: nil).builder?).to be_falsey
    end

    it 'returns false when moving or in production' do
      facility_unit = create(:unit, type: 'Facility')
      expect(build(:result, unit: facility_unit, ready_in: 1).builder?).to be false
      expect(build(:result, unit: facility_unit, ready_in: 0, destination: create(:planet)).builder?).to be false
    end
  end

  describe '#radar?' do
    it 'returns true only for CapitalShip with level >= 3' do
      cap = create(:unit, type: 'CapitalShip')
      fighter = create(:unit, type: 'Fighter')

      expect(build(:result, unit: cap, level: 3).radar?).to be true
      expect(build(:result, unit: cap, level: 2).radar?).to be false
      expect(build(:result, unit: fighter, level: 4).radar?).to be false
    end
  end

  describe 'cargo, capacity, used_capacity, available_capacity and weight' do
    it 'calculates total weight and remaining hanger/transport capacity' do
      carrier_unit = create(:unit, capacity: 10, weight: 20)
      fighter_unit = create(:unit, weight: 3)

      carrier = create(:result, unit: carrier_unit, quantity: 2) # capacity = 20, weight = 40
      embarked = create(:result, unit: fighter_unit, quantity: 4, carrier: carrier, round: carrier.round, planet: carrier.planet, squad: carrier.squad)

      expect(carrier.weight).to eq(40)
      expect(carrier.capacity).to eq(20)
      expect(carrier.cargo).to contain_exactly(embarked)
      expect(carrier.used_capacity).to eq(12)
      expect(carrier.available_capacity).to eq(8)
    end
  end

  describe '#influence' do
    it 'calculates influence only when stationary and ready' do
      unit = create(:unit, credits: 50, influence_ratio: 2)
      stationary = build(:result, unit: unit, quantity: 4, ready_in: 0, destination: nil)
      moving = build(:result, unit: unit, quantity: 4, ready_in: 0, destination: create(:planet))
      building = build(:result, unit: unit, quantity: 4, ready_in: 1, destination: nil)

      expect(stationary.influence).to eq(400)
      expect(moving.influence).to eq(0)
      expect(building.influence).to eq(0)
    end
  end
end