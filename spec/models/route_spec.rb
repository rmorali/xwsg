require 'rails_helper'

RSpec.describe Route, type: :model do
  it { should belong_to :vector_a }
  it { should belong_to :vector_b }
end
