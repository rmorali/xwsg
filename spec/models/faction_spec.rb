require 'rails_helper'

RSpec.describe Faction, type: :model do
  it { is_expected.to have_many :squads }

  it 'returns all faction names' do
    create(:faction, name: 'Empire')
    create(:faction, name: 'Mercenary')
    expect(Faction.names).to contain_exactly('Empire', 'Mercenary')
  end
end
