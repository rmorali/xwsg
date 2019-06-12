require 'rails_helper'

RSpec.describe ArmFleet, type: :service do
  let(:planet) { create(:planet) }
  let(:fleet) { create(:fleet) }
  let(:xwing) { create(:unit, type: 'Fighter') } 
  let(:armament) { create(:unit, type: 'Armament') }
  
  before do
  	@xwing = create(:fleet, quantity: 10, unit: xwing)
  end

  it 'arms a fleet with designed weapon' do
  	ArmFleet.new(@xwing, 10, armament).arm!
  	expect(@xwing.reload.armament).to eq(armament)
  end

  it 'arms a fleet partially' do
  end

  it 'disarms a fleet' do
  end
end