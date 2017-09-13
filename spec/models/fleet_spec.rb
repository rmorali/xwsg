require 'rails_helper'

RSpec.describe Fleet, type: :model do

  let(:unit) { create(:unit) }
  let(:squad) { create(:squad) }
  let(:planet) { create(:planet) }

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }

  it 'gets full built units' do
    unit.producing_time = 1
    unit.save
    fleet = Fleet.create(unit: unit, squad: squad, planet: planet, round: Round.get_current)
    expect(Fleet.operational).to_not include(fleet)
    Round.create
    expect(Fleet.operational).to include(fleet)
  end

end
