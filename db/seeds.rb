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
               { name: 'Empire', credits: 100, metals: 100, color: 'green', faction: Faction.first },
               { name: 'Rebel', credits: 100, metals: 100, color: 'red', faction: Faction.second }
             ])

emp = ['Empire']
reb = ['Rebel']
all = %w[Empire Rebel]

Unit.create(name: 'Shipyard', type: 'Facility', terrain: 'Space', hyperdrive: 0, producing_time: 2).factions = all
Unit.create(name: 'Star Destroyer', type: 'CapitalShip', terrain: 'Space', hyperdrive: 3, producing_time: 2).factions = emp
Unit.create(name: 'Nebulon Frigate', type: 'CapitalShip', terrain: 'Space', hyperdrive: 3, producing_time: 2).factions = all
Unit.create(name: 'X-Wing', type: 'Fighter', terrain: 'Space', hyperdrive: 1, producing_time: 2).factions = reb
Unit.create(name: 'Tie Fighter', type: 'Fighter', terrain: 'Space', hyperdrive: 0, producing_time: 2).factions = emp
Unit.create(name: 'Luke Skywalker', type: 'Diplomat', terrain: 'Special', hyperdrive: 0, producing_time: 2).factions = reb
Unit.create(name: 'Barrack', type: 'Facility', terrain: 'Ground', hyperdrive: 0, producing_time: 2).factions = all

anaxes = Planet.create(name: 'Anaxes', sector: 5, population: 1_502_500_345, x: 300, y: 10)
byss = Planet.create(name: 'Byss', sector: 5, population: 1_522_900_890, x: 50, y: 300)
corellia = Planet.create(name: 'Corellia', sector: 5, population: 2_102_270_234, x: 700, y: 600)
coruscant = Planet.create(name: 'Coruscant', sector: 5, population: 999_302_444_400, x: 500, y: 300)
fresia = Planet.create(name: 'Fresia', sector: 5, population: 7_902_070_999, x: 700, y: 10)
kuat = Planet.create(name: 'Kuat', sector: 5, population: 9_502_600_900, x: 900, y: 300)
mandalore = Planet.create(name: 'Mandalore', sector: 5, population: 202_055_077, x: 300, y: 600)

hoth = Planet.create(name: 'Hoth', sector: 4, population: 50_200_100, x: 500, y: 300)
tatooine = Planet.create(name: 'Tatooine', sector: 8, population: 15_900_500, x: 500, y: 300)
mon_calamari = Planet.create(name: 'Mon Calamari', sector: 6, population: 302_444_400, x: 500, y: 300)

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
               { vector_a: mandalore, vector_b: corellia, distance: 1 },
               { vector_a: kuat, vector_b: mon_calamari, distance: 1 },
               { vector_a: byss, vector_b: hoth, distance: 1 },
               { vector_a: corellia, vector_b: tatooine, distance: 1 }
             ])

 Fleet.create(unit: Unit.first, quantity: 1, squad: Squad.first, planet: coruscant, round: Round.current)
 Fleet.create(unit: Unit.second, quantity: 1, squad: Squad.first, planet: coruscant, round: Round.current)
 Fleet.create(unit: Unit.find(5), quantity: 15, squad: Squad.first, planet: coruscant, round: Round.current)

 Fleet.create(unit: Unit.first, quantity: 1, squad: Squad.second, planet: corellia, round: Round.current)
 Fleet.create(unit: Unit.third, quantity: 1, squad: Squad.second, planet: corellia, round: Round.current)
 Fleet.create(unit: Unit.find(4), quantity: 15, squad: Squad.second, planet: corellia, round: Round.current)
