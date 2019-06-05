# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faction.create([
                 { name: 'Empire' },
                 { name: 'Rebel' },
                 { name: 'Mercenary' }
               ])

Squad.create([
               { name: 'Empire', credits: 1000, metals: 2000, rare_elements: 50, color: 'green', faction: Faction.first },
               { name: 'Rebel', credits: 1000, metals: 2000, rare_elements: 50, color: 'red', faction: Faction.second },
               { name: 'Mercenary', credits: 1000, metals: 2000, rare_elements: 50, color: 'yellow', faction: Faction.third }
             ])

emp = ['Empire']
reb = ['Rebel']
all = %w[Empire Rebel Mercenary]

Unit.create(name: 'Shipyard', type: 'Facility', terrain: 'Space', credits: 1000, metals: 1000,
            hyperdrive: 0, producing_time: 2, weight: 50, capacity: 50, groupable: false, carriable: false).factions = all
Unit.create(name: 'Star Destroyer', type: 'CapitalShip', terrain: 'Space', credits: 500, metals: 500,
            hyperdrive: 3, producing_time: 2, weight: 10, capacity: 10, groupable: false, carriable: false).factions = emp
Unit.create(name: 'Nebulon Frigate', type: 'CapitalShip', terrain: 'Space', credits: 100, metals: 100,
            hyperdrive: 3, producing_time: 2, weight: 5, capacity: 5, groupable: false, carriable: false).factions = all
Unit.create(name: 'X-Wing', type: 'Fighter', terrain: 'Space', credits: 50, metals: 50,
            hyperdrive: 1, producing_time: 2, weight: 1, capacity: 0, groupable: true, carriable: true).factions = reb
Unit.create(name: 'Tie Fighter', type: 'Fighter', terrain: 'Space', credits: 10, metals: 10,
            hyperdrive: 0, producing_time: 2, weight: 1, capacity: 0, groupable: true, carriable: true).factions = emp
#Unit.create(name: 'Luke Skywalker', type: 'Diplomat', terrain: 'Special',
            #hyperdrive: 0, producing_time: 2, weight: 1, capacity: 0, groupable: true, carriable: true).factions = reb
#Unit.create(name: 'Barrack', type: 'Facility', terrain: 'Ground',
            #hyperdrive: 0, producing_time: 2, weight: 50, capacity: 50, groupable: false, carriable: false).factions = all

anaxes = Planet.create(name: 'Anaxes', sector: 1, population: 1_502_500_345, x: 26, y: 4)
byss = Planet.create(name: 'Byss', sector: 1, population: 1_522_900_890, x: 5, y: 38)
corellia = Planet.create(name: 'Corellia', sector: 1, population: 2_102_270_234, x: 60, y: 72)
coruscant = Planet.create(name: 'Coruscant', sector: 1, population: 999_302_444_400, x: 43, y: 38)
fresia = Planet.create(name: 'Fresia', sector: 1, population: 7_902_070_999, x: 60, y: 4)
kuat = Planet.create(name: 'Kuat', sector: 1, population: 9_502_600_900, x: 77, y: 38)
mandalore = Planet.create(name: 'Mandalore', sector: 1, population: 202_055_077, x: 26, y: 72)

Route.create([
               { vector_a: anaxes, vector_b: fresia, distance: 1 },
               { vector_a: anaxes, vector_b: byss, distance: 1 },
               { vector_a: anaxes, vector_b: coruscant, distance: 1 },
               { vector_a: fresia, vector_b: coruscant, distance: 1 },
               { vector_a: fresia, vector_b: kuat, distance: 1 },
               { vector_a: byss, vector_b: coruscant, distance: 1 },
               { vector_a: byss, vector_b: mandalore, distance: 1 },
               { vector_a: coruscant, vector_b: mandalore, distance: 1 },
               { vector_a: coruscant, vector_b: corellia, distance: 1 },
               { vector_a: coruscant, vector_b: kuat, distance: 1 },
               { vector_a: kuat, vector_b: corellia, distance: 1 },
               { vector_a: mandalore, vector_b: corellia, distance: 1 }
             ])

round = Round.current

Fleet.create(unit: Unit.first, quantity: 1, squad: Squad.first, planet: coruscant, round: round)
Fleet.create(unit: Unit.second, quantity: 1, squad: Squad.first, planet: coruscant, round: round)
Fleet.create(unit: Unit.find(4), quantity: 10, squad: Squad.first, planet: coruscant, round: round)
Fleet.create(unit: Unit.find(5), quantity: 10, squad: Squad.first, planet: coruscant, round: round)

Fleet.create(unit: Unit.first, quantity: 1, squad: Squad.second, planet: coruscant, round: round)
Fleet.create(unit: Unit.third, quantity: 1, squad: Squad.second, planet: coruscant, round: round)
Fleet.create(unit: Unit.find(4), quantity: 10, squad: Squad.second, planet: coruscant, round: round)
Fleet.create(unit: Unit.find(5), quantity: 10, squad: Squad.second, planet: coruscant, round: round)

Fleet.create(unit: Unit.first, quantity: 1, squad: Squad.third, planet: mandalore, round: round)
