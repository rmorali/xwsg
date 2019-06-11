Faction.create([
  { name: 'Empire' },
  { name: 'Rebel' },
  { name: 'Mercenary' },
  { name: 'Pirate' }
])

Squad.create([
  { name: 'Empire', credits: 1000, color: '#00FFFF', faction: Faction.first },
  { name: 'Rebel', credits: 1000, color: '#FF0000', faction: Faction.second },
])

User.create(email: 'setup@xwsg.com', password: '123456', squad: Squad.first)
User.create(email: 'rebel@rebel.com', password: '123456', squad: Squad.second)

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
kessel = Planet.create(name: 'Kessel', sector: 3, x: 1038, y: 475)
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
  { vector_a: concord_dawn, vector_b: kessel, distance: 1 },
  { vector_a: concord_dawn, vector_b: deathstar, distance: 1 },
  { vector_a: felucia, vector_b: mon_calamari, distance: 1 },
  { vector_a: felucia, vector_b: kashyyyk, distance: 1 },
  { vector_a: felucia, vector_b: kessel, distance: 1 },
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
  { vector_a: kuat, vector_b: kessel, distance: 1 },
  { vector_a: kessel, vector_b: kashyyyk, distance: 1 },
  { vector_a: kessel, vector_b: nal_hutta, distance: 1 },
  { vector_a: kessel, vector_b: corellia, distance: 1 },
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
Unit.create(name: 'Ind Complex', credits: 1200, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = emp_reb
Unit.create(name: 'Platforms', credits: 1800, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Asteroid Hangar', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Rebel Platform', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = reb
Unit.create(name: 'Golan I', credits: 2400, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all
Unit.create(name: 'Shipyard', credits: 3600, terrain: terrain, type: type, influence_ratio: ir,
  hyperdrive: 0, producing_time: 1, weight: 100, capacity: 100, groupable: false, carriable: false).factions = all

type = 'CapitalShip'
Unit.create(name: 'Corellian Gunship', credits: 300, terrain: terrain, type: type, influence_ratio: ir,
  description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = all
Unit.create(name: 'Corellian Corvette', credits: 300, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = all
Unit.create(name: 'Mod Corvette', credits: 300, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'Nebulon B Frigate', credits: 350, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = all
Unit.create(name: 'Mod Nebulon Frigate', credits: 400, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = all
Unit.create(name: 'Carrack Cruiser', credits: 350, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'Lancer Frigate', credits: 400, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'Marauder Corvette', credits: 500, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +1 nave simultanea no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 200, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'Dreadnaught', credits: 900, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'Escort Carrier', credits: 500, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'MC40A Light Cruiser', credits: 650, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = reb
Unit.create(name: 'Bulk Cruiser', credits: 750, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'Strike Cruiser', credits: 800, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = emp_reb
Unit.create(name: 'Assault Frigate', credits: 1150, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +2 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 400, groupable: false, carriable: false ).factions = reb
Unit.create(name: 'Mod Strike Cruiser', credits: 1150, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'MC80A Chatnoir Cruiser', credits: 1250, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = mand_merc
Unit.create(name: 'MC80 Reefhome Cruiser', credits: 1500, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = reb
Unit.create(name: 'Victory SD', credits: 1250, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'MC80 Liberty Cruiser', credits: 1500, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = reb
Unit.create(name: 'Victory SD II', credits: 1500, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'Interdictor', credits: 2000, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'Imperial SD', credits: 1800, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = emp
Unit.create(name: 'Imperial SD II', credits: 2000, terrain: terrain, type: type, influence_ratio: ir,
 description: 'Bonus +3 naves simultaneas no XWA', hyperdrive: 1, producing_time: 0, weight: 100, capacity: 600, groupable: false, carriable: false ).factions = emp

ir = 1
type = 'LightTransport'
Unit.create(name: 'YT-1300', credits: 100, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = merc
Unit.create(name: 'YT-2000', credits: 200, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = merc
Unit.create(name: 'YT-2400', credits: 150, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = mand
Unit.create(name: 'Millenium Falcon', credits: 180, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = merc_reb
Unit.create(name: 'Assault Transport', credits: 125, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = all
Unit.create(name: 'Escort Transport', credits: 125, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = reb
Unit.create(name: 'Assault Shuttle', credits: 125, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = emp
Unit.create(name: 'System Pat Craft', credits: 180, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = emp

type = 'HeavyTransport'
Unit.create(name: 'Container Transport', credits: 100, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = all
Unit.create(name: 'Modular Conveyor', credits: 100, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = all
Unit.create(name: 'Star Galleon', credits: 150, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = emp
Unit.create(name: 'Xyitiar Transport', credits: 100, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = mand_merc
Unit.create(name: 'Freighter', credits: 75, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: false ).factions = all

type = 'Fighter'
Unit.create(name: 'Z-95', credits: 35, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc_reb
Unit.create(name: 'Y-Wing', credits: 70, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = reb
Unit.create(name: 'X-Wing', credits: 80, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = reb
Unit.create(name: 'A-Wing', credits: 120, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = reb
Unit.create(name: 'B-Wing', credits: 145, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = reb
Unit.create(name: 'Pinook Fighter', credits: 35, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'Clockshape Fighter', credits: 55, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'Planetary Fighter', credits: 55, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'R-41 Starchaser', credits: 65, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'Razor Fighter', credits: 70, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'Skipray Blastboat', credits: 105, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = merc
Unit.create(name: 'T-Wing', credits: 35,  terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = mand
Unit.create(name: 'Preybird Fighter', credits: 50, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = mand
Unit.create(name: 'Supa Fighter', credits: 70, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = mand
Unit.create(name: 'Pursuer', credits: 80, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = mand
Unit.create(name: 'Firespray', credits: 95, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = mand
Unit.create(name: 'Tie Fighter*', credits: 20, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true, description: 'Sem Hyperdrive/Warheads' ).factions = emp
Unit.create(name: 'Tie Bomber*', credits: 25, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true, description: 'Sem Hyperdrive' ).factions = emp
Unit.create(name: 'Tie Interceptor*', credits: 30, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true, description: 'Sem Hyperdrive/Warheads' ).factions = emp
Unit.create(name: 'Tie Avenger', credits: 110, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = emp
Unit.create(name: 'Assault Gunboat', credits: 120, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = emp
Unit.create(name: 'Missile Boat', credits: 200, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = emp
Unit.create(name: 'Tie Defender', credits: 300, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 1, producing_time: 0, weight: 10, capacity: 0, groupable: true, carriable: true ).factions = emp

type = 'Armament'
Unit.create(name: 'Missile', :acronym => 'M', credits: 5, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Missile + Chaff', :acronym => 'M + Chaff', credits: 7, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Missile + Flare', :acronym => 'M + Flare', credits: 15, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Proton Torpedo', :acronym => 'PT', credits: 5, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Proton Torpedo + Chaff', :acronym => 'PT + Chaff', credits: 7, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Proton Torpedo + Flare', :acronym => 'PT + Flare', credits: 15, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Chaff', :acronym => 'Chaff', credits: 2, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all
Unit.create(name: 'Flare', :acronym => 'Flare', credits: 10, terrain: terrain, type: type, influence_ratio: ir,
 hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all

type = 'Trooper'
terrain = 'Ground'
Unit.create(name: 'Trooper', credits: 1, terrain: terrain, type: type, influence_ratio: ir,
hyperdrive: 0, producing_time: 0, weight: 1, capacity: 0, groupable: true, carriable: true ).factions = all

Setup.create(
  planet_income_ratio: 10,
  initial_credits: 6000,
  initial_planets: 2,
  initial_wormholes: 2,
  minimum_fleet_for_dominate: 10000,
  minimum_fleet_for_build: 1,
  builder_unit: 'CapitalShip',
  ai: true,
  ai_level: 3
)
AdminUser.create!(email: 'setup@xwsg.com', password: '123456', password_confirmation: '123456') if Rails.env.development?
