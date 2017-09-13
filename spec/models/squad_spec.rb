require 'rails_helper'

RSpec.describe Squad, type: :model do

  it { is_expected.to have_many :fleets }
  
end
