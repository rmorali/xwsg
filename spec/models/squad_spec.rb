require 'rails_helper'

RSpec.describe Squad, type: :model do

  it { should have_many :fleets }
  
end

