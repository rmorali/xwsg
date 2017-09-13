require 'rails_helper'

RSpec.describe Fleet, type: :model do

  let(:fleet) { create(:fleet) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }

  it 'gets full built units' do
    fleet.unit.producing_time = 1
    fleet.unit.save
    fleet.round = Round.get_current
    fleet.save  
    expect(Fleet.operational).to_not include(fleet)
    Round.create
    expect(Fleet.operational).to include(fleet)
  end

end
