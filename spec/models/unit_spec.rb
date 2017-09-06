require 'rails_helper'

RSpec.describe Unit, type: :model do

  let(:unit) { create(:unit) }

  it { expect(unit).to be_an_instance_of(Unit) }
  it { expect(unit.name).to be_a(String) }



   
end
#### Sample #####
# RSpec.describe User, :type => :model do
#  it "orders by last name" do
#    lindeman = User.create!(first_name: "Andy", last_name: "Lindeman")
#    chelimsky = User.create!(first_name: "David", last_name: "Chelimsky")
#    expect(User.ordered_by_last_name).to eq([chelimsky, lindeman])
#  end
# end
