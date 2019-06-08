FactoryGirl.define do
  factory :admin_user do

  end
  factory :user do
  end
  factory :round do
    phase 0
  end
  factory :faction do
    name 'Empire'
  end
  factory :fleet do
    quantity 1
    association :unit, factory: :unit
    association :squad, factory: :squad
    association :planet, factory: :planet
    association :round, factory: :round
  end
  factory :squad do
    name 'DarkSide Squadron'
    association :faction, factory: :faction
    credits 1000
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
    sector 1
    population 1000
    credits 1000
    x 1
    y 1
  end
  factory :unit, aliases: %i[ship facility] do
    name Faker::StarWars.vehicle
    acronym 'CS'
    type 'CapitalShip'
    terrain 'Space'
    hyperdrive 1
    credits 1
    producing_time 1
    influence_ratio 1
    weight 1
    capacity 0
    groupable true
    carriable true
    description 'Descricao'
    all = %w[Empire Rebel Mercenary Pirate]
    factions all
  end
  factory :result do
    association :round, factory: :round
    association :unit, factory: :unit
    association :planet, factory: :planet
    association :fleet, factory: :fleet
    association :squad, factory: :squad
    quantity 10
    final_quantity 0
  end
  factory :setup do
    planet_income_ratio 1
    initial_credits 2400
    initial_planets 2
    initial_wormholes 2
    minimum_fleet_for_dominate 10000
    minimum_fleet_for_build 10
    builder_unit 'Trooper'
    ai true
    ai_level 1
  end
end
