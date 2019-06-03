require 'rails_helper'

RSpec.describe Combat, type: :model do

  it { is_expected.to belong_to :round }
  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :fleet }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :captor }  

end