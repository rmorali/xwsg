require 'rails_helper'

RSpec.describe ArmFleet, type: :service do
  let(:planet) { build(:planet) }
  let(:squad) { create(:squad, credits: 1000) }
  let(:xwing) { build(:unit, type: 'Fighter') } 
  let(:facility) { build(:unit, type: 'Facility') }
  let(:strike_cruiser) { build(:unit, type: 'CapitalShip') }
  let(:armament) { build(:unit, type: 'Armament') }
  
  before(:each) do
  	@xwing = create(:fleet, quantity: 10, squad: squad, unit: xwing)
  end

  it 'arms if has credits' do
  	squad.update(credits: 5)
    ArmFleet.new(@xwing, 10, armament).arm!
    expect(@xwing.reload.quantity).to eq(10)
    expect(@xwing.reload.armament).to_not eq(armament)
  end
  it 'arms a fleet with designed weapon' do
  	ArmFleet.new(@xwing, 10, armament).arm!
  	expect(Fleet.last.unit).to eq(xwing)
  	expect(Fleet.last.armament).to eq(armament)
  end

  it 'arms a fleet partially' do
  	ArmFleet.new(@xwing, 6, armament).arm!
  	expect(@xwing.reload.armament).to_not eq(armament)
  	expect(@xwing.reload.quantity).to eq(4)
  	expect(Fleet.last.quantity).to eq(6)
  	expect(Fleet.last.armament).to eq(armament)
  end

  it 'disarms a fleet' do
  end
end