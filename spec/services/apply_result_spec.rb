require 'rails_helper'

RSpec.describe ApplyResult, type: :service do
  let(:planet) { create(:planet) }
  before(:each) do
    @squad_a = create(:squad)
    @squad_b = create(:squad)
    @fleet_a = create(:fleet, quantity: 10, squad: @squad_a, planet: planet)
    @fleet_b = create(:fleet, quantity:10, squad: @squad_b, planet: planet)
    CreateResult.new.create!
    @result = Result.first
    @fleet = @result.fleet
  end
  context 'blasted units' do
    it 'all of them' do
      @result.update(blasted: 10)
      ApplyResult.new(@result).blast!
      expect(@result.reload.fleet).to be nil
    end
    it 'only one' do
      @result.update(blasted: 1)
      ApplyResult.new(@result).blast!
      expect(@fleet.quantity).to eq(9)
    end
  end
  context 'Fled units' do
    before do
      @destination = create(:planet)
      @route = create(:route, vector_a: planet, vector_b: @destination)
    end
    it 'all of them' do
      @result.update(fled: 10)
      ApplyResult.new(@result).flee!
      expect(@result.reload.fleet).to be nil
      expect(Fleet.last.quantity).to eq(10)
      expect(Fleet.last.planet).to eq(@destination)
    end
    it 'only one' do
      @result.update(fled: 1)
      ApplyResult.new(@result).flee!
      expect(@result.reload.fleet.quantity).to eq(9)
      expect(Fleet.last.quantity).to eq(1)
      expect(Fleet.last.planet).to eq(@destination)
    end
  end
  context 'captured units' do
    it 'all of them' do
      @result.update(captured: 10, captor: @squad_b)
      ApplyResult.new(@result).capture!
      expect(@result.reload.fleet).to be nil
      expect(Fleet.last.quantity).to eq(10)
      expect(Fleet.last.squad).to eq(@squad_b)
    end
    it 'only one' do
      @result.update(captured: 1, captor: @squad_b)
      ApplyResult.new(@result).capture!
      expect(@result.reload.fleet.quantity).to eq(9)
      expect(Fleet.last.quantity).to eq(1)
      expect(Fleet.last.squad).to eq(@squad_b)
    end
  end
end
