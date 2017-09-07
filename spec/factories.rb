FactoryGirl.define do
  factory :unit, aliases: [:ship, :facility] do
    name Faker::Name.name
    acronym "SIGLA"
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
