# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

empire = ['empire']
rebel = ['rebel']
all = ['empire','rebel']

Unit.create(name: 'X-Wing', type: 'Fighter', terrain: 'Space', hyperdrive: 1).factions = rebel
Unit.create(name: 'Tie Fighter', type: 'Fighter', terrain: 'Space', hyperdrive: 0).factions = empire
Unit.create(name: 'Luke Skywalker', type: 'Diplomat', terrain: 'Special', hyperdrive: 0).factions = all

coruscant = Planet.create(name: 'Coruscant', sector: 'Core', population: 17502500900)
hoth = Planet.create(name: 'Hoth', sector: 'Unknown', population: 50200100)
naboo = Planet.create(name: 'Naboo', sector: 'Unknown', population: 100200900)
tatooine = Planet.create(name: 'Tatooine', sector: 'HuttSpace', population: 15900500)

Route.create([
  {vector_a: coruscant, vector_b: hoth, distance: 1 },
  {vector_a: hoth, vector_b: naboo, distance: 1},
  {vector_a: naboo, vector_b: tatooine, distance: 1}
  ])
