require 'rails_helper'

RSpec.describe GroupFleet, type: :service do
  before(:each) do
    @planet = create(:planet)
    @squad = create(:squad)
    @fighter = create(:unit, type: 'Fighter')
    @capital_ship = create(:unit, type: 'CapitalShip', groupable: false)
    @facility = create(:unit, type: 'Facility', groupable: false)
    2.times do
      create(:fleet,
             unit: @fighter,
             squad: @squad,
             planet: @planet,
             quantity: 2,
             destination: @planet,
             arrives_in: nil,
             carrier: nil,
             ready_in: nil)
    end
  end
  it 'groups identical fleets' do
    expect(Fleet.all.count).to_not eq(1)
    GroupFleet.new(@planet).group!
    expect(Fleet.all.count).to eq(1)
  end
  it 'updates the quantity of the grouped fleet' do
    GroupFleet.new(@planet).group!
    expect(Fleet.first.quantity).to be 4
  end
  it 'do not group not groupable fleets' do
    Fleet.first.update(unit: @capital_ship)
    GroupFleet.new(@planet).group!
    expect(Fleet.all.count).to_not eq(1)
    Fleet.first.update(unit: @facility)
    GroupFleet.new(@planet).group!
    expect(Fleet.all.count).to_not eq(1)
  end
end
