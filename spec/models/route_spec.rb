require 'rails_helper'

RSpec.describe Route, type: :model do

  it { is_expected.to belong_to :vector_a }
  it { is_expected.to belong_to :vector_b }
  
end
