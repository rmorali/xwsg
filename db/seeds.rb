
bespin = Planet.create(name: 'Bespin', sector: 1, x: 363, y: 475)
bonadan = Planet.create(name: 'Bonadan', sector: 3, x: 1488, y: 475)
concord_dawn = Planet.create(name: 'Concord Dawn', sector: 2, x: 925, y: 250)
corellia = Planet.create(name: 'Corellia', sector: 2, x: 813, y: 475)
coruscant = Planet.create(name: 'Coruscant', sector: 2, x: 475, y: 250)
dagobah = Planet.create(name: 'Dagobah', sector: 4, x: 475, y: 1150)
deathstar = Planet.create(name: 'Death Star', sector: 2, x: 700, y: 250)
endor = Planet.create(name: 'Endor', sector: 1, x: 250, y: 700)
felucia = Planet.create(name: 'Felucia', sector: 3, x: 1150, y: 250)
geonosis = Planet.create(name: 'Geonosis', sector: 4, x: 813, y: 925)
haruun_kal = Planet.create(name: 'Haruun Kal', sector: 4, x: 700, y: 700)
hoth = Planet.create(name: 'Hoth', sector: 1, x: 475, y: 700)
ilum = Planet.create(name: 'Ilum', sector: 1, x: 250, y: 250)
kamino = Planet.create(name: 'Kamino', sector: 3, x: 1375, y: 700)
kashyyyk = Planet.create(name: 'Kashyyyk', sector: 3, x: 1263, y: 475)
kessel_asteroids = Planet.create(name: 'Kessel Asteroids', sector: 3, x: 1038, y: 475)
kuat = Planet.create(name: 'Kuat', sector: 4, x: 925, y: 700)
mandalore = Planet.create(name: 'Mandalore', sector: 2, x: 588, y: 475)
mon_calamari = Planet.create(name: 'Mon Calamari', sector: 3, x: 1375, y: 250)
mustafar = Planet.create(name: 'Mustafar', sector: 1, x: 138, y: 925)
mygeeto = Planet.create(name: 'Mygeeto', sector: 2, x: 588, y: 25)
naboo = Planet.create(name: 'Naboo', sector: 4, x: 588, y: 925)
nal_hutta = Planet.create(name: 'Nal Hutta', sector: 3, x: 1150, y: 700)
ord_ibanna = Planet.create(name: 'Ord Ibanna', sector: 1, x: 363, y: 925)
polis_massa = Planet.create(name: 'Polis Massa', sector: 1, x: 25, y: 700)
rattatak = Planet.create(name: 'Rattatak', sector: 1, x: 138, y: 475)
rhen_var = Planet.create(name: 'Rhen Var', sector: 3, x: 1038, y: 25)
ryloth = Planet.create(name: 'Ryloth', sector: 4, x: 925, y: 1150)
tatooine = Planet.create(name: 'Tatooine', sector: 4, x: 1038, y: 925)
utapau = Planet.create(name: 'Utapau', sector: 4, x: 700, y: 1150)
yavin = Planet.create(name: 'Yavin', sector: 2, x: 813, y: 25)

Route.create([
  { vector_a: mygeeto, vector_b: yavin, distance: 1 },
  { vector_a: mygeeto, vector_b: deathstar, distance: 1 },
  { vector_a: mygeeto, vector_b: coruscant, distance: 1 },
  { vector_a: yavin, vector_b: rhen_var, distance: 1 },
  { vector_a: yavin, vector_b: deathstar, distance: 1 },
  { vector_a: yavin, vector_b: concord_dawn, distance: 1 },
  { vector_a: rhen_var, vector_b: felucia, distance: 1 },
  { vector_a: rhen_var, vector_b: concord_dawn, distance: 1 },
  { vector_a: deathstar, vector_b: coruscant, distance: 1 },
  { vector_a: coruscant, vector_b: mandalore, distance: 1 },
  { vector_a: coruscant, vector_b: bespin, distance: 1 },
  { vector_a: corellia, vector_b: concord_dawn, distance: 1 },
  { vector_a: corellia, vector_b: kuat, distance: 1 },
  { vector_a: mandalore, vector_b: corellia, distance: 1 },
  { vector_a: mandalore, vector_b: deathstar, distance: 1 },
  { vector_a: concord_dawn, vector_b: felucia, distance: 1 },
  { vector_a: concord_dawn, vector_b: kessel_asteroids, distance: 1 },
  { vector_a: concord_dawn, vector_b: deathstar, distance: 1 },
  { vector_a: felucia, vector_b: mon_calamari, distance: 1 },
  { vector_a: felucia, vector_b: kashyyyk, distance: 1 },
  { vector_a: felucia, vector_b: kessel_asteroids, distance: 1 },
  { vector_a: mon_calamari, vector_b: bonadan, distance: 1 },
  { vector_a: mon_calamari, vector_b: kashyyyk, distance: 1 },
  { vector_a: endor, vector_b: bespin, distance: 1 },
  { vector_a: endor, vector_b: hoth, distance: 1 },
  { vector_a: endor, vector_b: rattatak, distance: 1 },
  { vector_a: endor, vector_b: ord_ibanna, distance: 1 },
  { vector_a: endor, vector_b: polis_massa, distance: 1 },
  { vector_a: rattatak, vector_b: polis_massa, distance: 1 },
  { vector_a: bespin, vector_b: rattatak, distance: 1 },
  { vector_a: bespin, vector_b: mandalore, distance: 1 },
  { vector_a: bespin, vector_b: hoth, distance: 1 },
  { vector_a: corellia, vector_b: deathstar, distance: 1 },
  { vector_a: corellia, vector_b: haruun_kal, distance: 1 },
  { vector_a: kuat, vector_b: kessel_asteroids, distance: 1 },
  { vector_a: kessel_asteroids, vector_b: kashyyyk, distance: 1 },
  { vector_a: kessel_asteroids, vector_b: nal_hutta, distance: 1 },
  { vector_a: kessel_asteroids, vector_b: corellia, distance: 1 },
  { vector_a: kashyyyk, vector_b: bonadan, distance: 1 },
  { vector_a: kashyyyk, vector_b: kamino, distance: 1 },
  { vector_a: kashyyyk, vector_b: nal_hutta, distance: 1 },
  { vector_a: ilum, vector_b: rattatak, distance: 1 },
  { vector_a: ilum, vector_b: coruscant, distance: 1 },
  { vector_a: ilum, vector_b: bespin, distance: 1 },
  { vector_a: hoth, vector_b: haruun_kal, distance: 1 },
  { vector_a: hoth, vector_b: ord_ibanna, distance: 1 },
  { vector_a: hoth, vector_b: mandalore, distance: 1 },
  { vector_a: hoth, vector_b: naboo, distance: 1 },
  { vector_a: haruun_kal, vector_b: naboo, distance: 1 },
  { vector_a: haruun_kal, vector_b: mandalore, distance: 1 },
  { vector_a: haruun_kal, vector_b: geonosis, distance: 1 },
  { vector_a: haruun_kal, vector_b: kuat, distance: 1 },
  { vector_a: kuat, vector_b: nal_hutta, distance: 1 },
  { vector_a: kuat, vector_b: tatooine, distance: 1 },
  { vector_a: kuat, vector_b: geonosis, distance: 1 },
  { vector_a: nal_hutta, vector_b: kamino, distance: 1 },
  { vector_a: nal_hutta, vector_b: tatooine, distance: 1 },
  { vector_a: bonadan, vector_b: kamino, distance: 1 },
  { vector_a: mustafar, vector_b: endor, distance: 1 },
  { vector_a: mustafar, vector_b: polis_massa, distance: 1 },
  { vector_a: mustafar, vector_b: ord_ibanna, distance: 1 },
  { vector_a: ord_ibanna, vector_b: naboo, distance: 1 },
  { vector_a: ord_ibanna, vector_b: dagobah, distance: 1 },
  { vector_a: naboo, vector_b: geonosis, distance: 1 },
  { vector_a: naboo, vector_b: utapau, distance: 1 },
  { vector_a: naboo, vector_b: dagobah, distance: 1 },
  { vector_a: geonosis, vector_b: tatooine, distance: 1 },
  { vector_a: geonosis, vector_b: ryloth, distance: 1 },
  { vector_a: geonosis, vector_b: utapau, distance: 1 },
  { vector_a: dagobah, vector_b: utapau, distance: 1 },
  { vector_a: utapau, vector_b: ryloth, distance: 1 },
  { vector_a: ryloth, vector_b: tatooine, distance: 1 }
])

emp = ['Empire']
reb = ['Rebel']
emp_reb = ['Empire','Rebel']
merc = ['Mercenary']
merc_reb = ['Mercenary','Rebel']
mand = ['Pirate']
mand_merc = ['Pirate','Mercenary']
none = ['Nenhuma']
all = %w[Empire Rebel Mercenary Pirate]

type = 'Facility'
terrain = 'Space'
ir = 10
Unit.create(name: 'Ind.Complex', credits: 1200, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = emp_reb
Unit.create(name: 'Platforms', credits: 1800, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Asteroid Hangar', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Rebel Platform', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = reb
Unit.create(name: 'Golan I', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Shipyard', credits: 3600, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 2, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all

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

User.create(email: 'setup@xwsg.com', password: '123456', squad: Squad.first)