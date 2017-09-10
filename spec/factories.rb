FactoryGirl.define do
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
    acronym "MR"
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
