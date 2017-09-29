require 'rails_helper'

RSpec.describe UpdateFleet, type: :service do
  let(:unit) { create(:unit) }
  before do
    @empire = create(:squad)
    @rebel = create(:squad)
    @round = Round.current
    @origin = create(:planet)
    @destination = create(:planet)
    @far_destination = create(:planet)
    Route.create(vector_a: @origin, vector_b: @destination, distance: 1)
    Route.create(vector_a: @destination, vector_b: @far_destination, distance: 1)
    @xwing = create(:fleet, quantity: 10, unit: unit, squad: @rebel, planet: @origin, round: Round.current)
    @strike_cruiser = create(:fleet, quantity: 1, unit: unit, squad: @empire, planet: @origin, round: Round.current)
    OrderMovement.new(@xwing, 10, @destination).move!
    OrderMovement.new(@strike_cruiser, 1, @far_destination).move!
  end
  it 'updates travelling fleets situation' do
    expect(@strike_cruiser.planet).to eq(@origin)
    expect(@strike_cruiser.arrives_in).to eq(2)
    UpdateFleet.new.moving
    expect(@strike_cruiser.reload.arrives_in).to eq(1)
    expect(@strike_cruiser.reload.planet).to eq(@origin)
  end
  it 'updates arriving fleets location' do
    expect(@xwing.planet).to eq(@origin)
    UpdateFleet.new.moving
    expect(@xwing.reload.planet).to eq(@destination)
    expect(@strike_cruiser.reload.planet).to eq(@origin)
    UpdateFleet.new.moving
    expect(@strike_cruiser.reload.arrives_in).to eq(nil)
    expect(@strike_cruiser.reload.planet).to eq(@far_destination)
  end

end
