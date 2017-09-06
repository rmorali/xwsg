FactoryGirl.define do
  factory :unit, aliases: [:ship, :facility] do
    name Faker::Name.name
  end
end
