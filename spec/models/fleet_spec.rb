require 'rails_helper'

RSpec.describe Fleet, type: :model do

  it { is_expected.to belong_to :unit }
  it { is_expected.to belong_to :squad }
  it { is_expected.to belong_to :planet }
  it { is_expected.to belong_to :round }

end
