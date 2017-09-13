FactoryGirl.define do
  factory :round do
    phase 0
  end
  factory :faction do
    name "Empire"
  end
  factory :fleet do
    quantity 1
    association :unit, factory: :unit
    association :squad, factory: :squad
    association :planet, factory: :planet
  end
  factory :squad do
    name 'DarkSide Squadron'
    association :faction, factory: :faction
    credits 1
    metals 1
    rare_elements 1
    url Faker::Internet.url('squad.com')
    ready false
  end
  factory :route do
    association :vector_a, factory: :planet
    association :vector_b, factory: :planet
    distance 1
  end
  factory :planet do
    name Faker::StarWars.planet
    sector Faker::Space.constellation
    population 1000
    credits 1
    metals 1
    rare_elements 1
    x 1
    y 1
  end
  factory :unit, aliases: [:ship, :facility] do
    name Faker::StarWars.vehicle
    acronym "CS"
    type "CapitalShip"
    terrain "Space"
    hyperdrive 1
    credits 1
    metals 1
    rare_elements 1
    producing_time 1
    load_weigth 1
    load_capacity 1
    groupable true
    faction_mask 0
  end
end
