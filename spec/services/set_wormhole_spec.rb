require 'rails_helper'

RSpec.describe SetWormhole, type: :service do
  before do
    @setup = create(:setup, initial_wormholes: 2)
    5.times { create(:planet) }
  end

  it 'creates wormholes' do
    SetWormhole.new.create!
    expect(Route.count).to eq(2)
  end

end
