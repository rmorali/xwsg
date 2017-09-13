require 'rails_helper'

RSpec.describe Fleet, type: :model do
    it { should belong_to :squad }
    it { should belong_to :unit }
    it { should belong_to :planet }
end
