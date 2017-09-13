require 'rails_helper'

RSpec.describe Squad, type: :model do

  it { is_expected.to have_many :fleets }
  it { is_expected.to belong_to :faction }

end
