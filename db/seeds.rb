# frozen_string_literal: true

# ==============================================================================
# 1. FACÇÕES, SQUADS & USUÁRIO INICIAL
# ==============================================================================
Faction.create!([
  { name: 'Empire' },
  { name: 'Rebel' },
  { name: 'Mercenary' },
  { name: 'Mandalorians' }
])

faction = Faction.first
Squad.create!(name: 'BOT Empire', color: '#00FF00', faction: faction, ai: true, ai_level: 4)
User.create!(email: 'setup@xwsg.com', password: '123456', squad: Squad.first)

# ==============================================================================
# 2. MAPA GALÁCTICO (PLANETAS & ROTAS)
# ==============================================================================
bespin       = Planet.create!(name: 'Bespin', sector: 1, x: 363, y: 475, credits: 0)
bonadan      = Planet.create!(name: 'Bonadan', sector: 2, x: 1488, y: 475, credits: 0)
concord_dawn = Planet.create!(name: 'Concord Dawn', sector: 2, x: 925, y: 250, credits: 0)
corellia     = Planet.create!(name: 'Corellia', sector: 2, x: 813, y: 475, credits: 0)
coruscant    = Planet.create!(name: 'Coruscant', sector: 1, x: 475, y: 250, credits: 0)
dagobah      = Planet.create!(name: 'Dagobah', sector: 3, x: 475, y: 1150, credits: 0)
deathstar    = Planet.create!(name: 'Death Star', sector: 1, x: 700, y: 250, credits: 0)
endor        = Planet.create!(name: 'Endor', sector: 3, x: 250, y: 700, credits: 0)
felucia      = Planet.create!(name: 'Felucia', sector: 2, x: 1150, y: 250, credits: 0)
geonosis     = Planet.create!(name: 'Geonosis', sector: 4, x: 813, y: 925, credits: 0)
haruun_kal   = Planet.create!(name: 'Haruun Kal', sector: 4, x: 700, y: 700, credits: 0)
hoth         = Planet.create!(name: 'Hoth', sector: 3, x: 475, y: 700, credits: 0)
ilum         = Planet.create!(name: 'Ilum', sector: 1, x: 250, y: 250, credits: 0)
kamino       = Planet.create!(name: 'Kamino', sector: 4, x: 1375, y: 700, credits: 0)
kashyyyk     = Planet.create!(name: 'Kashyyyk', sector: 2, x: 1263, y: 475, credits: 0)
kessel       = Planet.create!(name: 'Kessel', sector: 2, x: 1038, y: 475, credits: 0)
kuat         = Planet.create!(name: 'Kuat', sector: 4, x: 925, y: 700, credits: 0)
mandalore    = Planet.create!(name: 'Mandalore', sector: 1, x: 588, y: 475, credits: 0)
mon_calamari = Planet.create!(name: 'Mon Calamari', sector: 2, x: 1375, y: 250, credits: 0)
mustafar     = Planet.create!(name: 'Mustafar', sector: 3, x: 138, y: 925, credits: 0)
mygeeto      = Planet.create!(name: 'Mygeeto', sector: 1, x: 588, y: 25, credits: 0)
naboo        = Planet.create!(name: 'Naboo', sector: 3, x: 588, y: 925, credits: 0)
nal_hutta    = Planet.create!(name: 'Nal Hutta', sector: 4, x: 1150, y: 700, credits: 0)
ord_ibanna   = Planet.create!(name: 'Ord Ibanna', sector: 3, x: 363, y: 925, credits: 0)
polis_massa  = Planet.create!(name: 'Polis Massa', sector: 3, x: 25, y: 700, credits: 0)
rattatak     = Planet.create!(name: 'Rattatak', sector: 1, x: 138, y: 475, credits: 0)
rhen_var     = Planet.create!(name: 'Rhen Var', sector: 2, x: 1038, y: 25, credits: 0)
ryloth       = Planet.create!(name: 'Ryloth', sector: 4, x: 925, y: 1150, credits: 0)
tatooine     = Planet.create!(name: 'Tatooine', sector: 4, x: 1038, y: 925, credits: 0)
utapau       = Planet.create!(name: 'Utapau', sector: 3, x: 700, y: 1150, credits: 0)
yavin        = Planet.create!(name: 'Yavin', sector: 1, x: 813, y: 25, credits: 0)

Route.create!([
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

# ==============================================================================
# 3. CATÁLOGO DE UNIDADES (XWSG 1.7 ATUALIZADO)
# ==============================================================================
emp       = ['Empire']
reb       = ['Rebel']
emp_reb   = %w[Empire Rebel]
merc      = ['Mercenary']
mand      = ['Mandalorians']
mand_merc = %w[Mercenary Mandalorians]
all       = %w[Empire Rebel Mercenary Mandalorians]

def seed_unit(factions, attrs)
  unit = Unit.create!(attrs)
  unit.factions = factions
  unit
end

# ------------------------------------------------------------------------------
# 3.1 FACILITIES (type: 'Facility')
# ------------------------------------------------------------------------------
[
  {
    name: 'Industrial Complex', acronym: 'INC', factions: all,
    credits: 1800, producing_time: 1, hyperdrive: 0, shield: 2560, hull: 1216,
    laser_attack: 6, ion_attack: 6, ordnance_attack: 0,
    speed: 0, acceleration: 0, maneuverability: 0, armor_class: 5, morale: 90,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 100, capacity: 100, influence_ratio: 10,
    groupable: false, carriable: false, armable: false, armory: true,
    description: 'Complexo industrial armado (900 pts produção)'
  },
  {
    name: 'Golan I Defense Station', acronym: 'G/1', factions: all,
    credits: 2400, producing_time: 1, hyperdrive: 0, shield: 3200, hull: 1520,
    laser_attack: 0, ion_attack: 19, ordnance_attack: 0,
    speed: 0, acceleration: 0, maneuverability: 0, armor_class: 5, morale: 100,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 100, capacity: 100, influence_ratio: 10,
    groupable: false, carriable: false, armable: false, armory: true,
    description: 'Estação orbital de defesa planetária (1200 pts)'
  },
  {
    name: 'Golan III Fortress', acronym: 'G/3', factions: emp_reb,
    credits: 3600, producing_time: 1, hyperdrive: 0, shield: 8000, hull: 3040,
    laser_attack: 2, ion_attack: 27, ordnance_attack: 0,
    speed: 0, acceleration: 0, maneuverability: 0, armor_class: 5, morale: 100,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 100, capacity: 100, influence_ratio: 10,
    groupable: false, carriable: false, armable: false, armory: true,
    description: 'Fortaleza orbital pesada (1800 pts)'
  },
  {
    name: 'Asteroid Hangar', acronym: 'ASTHAN', factions: mand_merc,
    credits: 2400, producing_time: 1, hyperdrive: 0, shield: 2560, hull: 2272,
    laser_attack: 12, ion_attack: 0, ordnance_attack: 0,
    speed: 0, acceleration: 0, maneuverability: 0, armor_class: 5, morale: 90,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 100, capacity: 100, influence_ratio: 10,
    groupable: false, carriable: false, armable: false, armory: true,
    description: 'Base armada oculta em asteroide (1200 pts)'
  }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, { terrain: 'Space', type: 'Facility' }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.2 CAPITAL SHIPS (type: 'CapitalShip')
# ------------------------------------------------------------------------------
[
  {
    name: 'Corellian Corvette', acronym: 'CRV', factions: all,
    credits: 300, producing_time: 0, hyperdrive: 1, shield: 640, hull: 400,
    laser_attack: 6, ion_attack: 0, ordnance_attack: 0,
    speed: 50, acceleration: 8, maneuverability: 32, armor_class: 3, morale: 65,
    capacity: 200, description: '[Corveta] Bonus +1 nave no XWA; recua se perder >40% Hull'
  },
  {
    name: 'Nebulon B Frigate', acronym: 'FRG', factions: emp_reb,
    credits: 350, producing_time: 0, hyperdrive: 1, shield: 960, hull: 600,
    laser_attack: 12, ion_attack: 4, ordnance_attack: 0,
    speed: 35, acceleration: 6, maneuverability: 22, armor_class: 3, morale: 72,
    capacity: 200, description: '[Fragata] Bonus +1 nave no XWA; fragata de escolta padrão'
  },
  {
    name: 'Dreadnaught', acronym: 'DRD', factions: mand_merc,
    credits: 900, producing_time: 0, hyperdrive: 1, shield: 2200, hull: 1500,
    laser_attack: 22, ion_attack: 4, ordnance_attack: 0,
    speed: 20, acceleration: 4, maneuverability: 12, armor_class: 4, morale: 75,
    capacity: 400, description: '[Cruzador Médio] Bonus +2 naves no XWA; cruzador robusto independente'
  },
  {
    name: 'MC40A Light Cruiser', acronym: 'MC40A', factions: reb,
    credits: 650, producing_time: 0, hyperdrive: 1, shield: 1600, hull: 950,
    laser_attack: 16, ion_attack: 6, ordnance_attack: 8,
    speed: 32, acceleration: 5, maneuverability: 20, armor_class: 4, morale: 78,
    capacity: 400, description: '[Cruzador Leve] Bonus +2 naves no XWA; cruzador rápido Rebelde'
  },
  {
    name: 'MC80 Liberty Cruiser', acronym: 'MC80L', factions: reb,
    credits: 1500, producing_time: 0, hyperdrive: 1, shield: 3800, hull: 2200,
    laser_attack: 36, ion_attack: 12, ordnance_attack: 6,
    speed: 22, acceleration: 4, maneuverability: 13, armor_class: 4, morale: 85,
    capacity: 600, description: '[Cruzador Pesado] Bonus +3 naves no XWA; linha de frente Rebelde'
  },
  {
    name: 'MC85A HomeOne Cruiser', acronym: 'MC85A', factions: reb,
    credits: 6000, producing_time: 2, hyperdrive: 1, shield: 9600, hull: 5400,
    laser_attack: 75, ion_attack: 25, ordnance_attack: 16,
    speed: 15, acceleration: 3, maneuverability: 8, armor_class: 5, morale: 95,
    capacity: 600, description: '[Nave Capitânia] Bonus +3 naves no XWA; capitânia suprema Rebelde'
  },
  {
    name: 'Lancer Frigate', acronym: 'LNC', factions: emp,
    credits: 400, producing_time: 0, hyperdrive: 1, shield: 800, hull: 520,
    laser_attack: 20, ion_attack: 0, ordnance_attack: 0,
    speed: 40, acceleration: 7, maneuverability: 25, armor_class: 3, morale: 75,
    capacity: 200, description: '[Fragata Anti-Caça] Bonus +1 nave no XWA; varredura de caças'
  },
  {
    name: 'Imperial Star Destroyer', acronym: 'ISD', factions: emp,
    credits: 1800, producing_time: 0, hyperdrive: 1, shield: 4400, hull: 2800,
    laser_attack: 44, ion_attack: 14, ordnance_attack: 8,
    speed: 18, acceleration: 3, maneuverability: 10, armor_class: 4, morale: 88,
    capacity: 600, description: '[Destroyer Estelar] Bonus +3 naves no XWA; pilar da frota Imperial'
  },
  {
    name: 'Interdictor', acronym: 'INT', factions: emp,
    credits: 2000, producing_time: 0, hyperdrive: 1, shield: 3400, hull: 2200,
    laser_attack: 24, ion_attack: 12, ordnance_attack: 0,
    speed: 20, acceleration: 4, maneuverability: 12, armor_class: 4, morale: 80,
    capacity: 600, description: '[Cruzador Tático] Bonus +3 naves no XWA; bloqueia salto hiperespacial'
  },
  {
    name: 'Super Star Destroyer', acronym: 'SSD', factions: emp,
    credits: 7000, producing_time: 2, hyperdrive: 1, shield: 12000, hull: 7500,
    laser_attack: 95, ion_attack: 30, ordnance_attack: 24,
    speed: 12, acceleration: 2, maneuverability: 5, armor_class: 5, morale: 98,
    capacity: 600, description: '[Dreadnought] Bonus +3 naves no XWA; colosso supremo Imperial'
  },
  {
    name: 'Radiant VII Light Cruiser', acronym: 'RCC', factions: merc,
    credits: 500, producing_time: 0, hyperdrive: 1, shield: 800, hull: 420,
    laser_attack: 8, ion_attack: 2, ordnance_attack: 0,
    speed: 27, acceleration: 5, maneuverability: 20, armor_class: 3, morale: 60,
    capacity: 200, description: '[Cruzador Leve] Bonus +1 nave no XWA; recua cedo sob fogo pesado'
  },
  {
    name: 'Assault Frigate', acronym: 'AFRG', factions: merc,
    credits: 1150, producing_time: 0, hyperdrive: 1, shield: 2600, hull: 1650,
    laser_attack: 26, ion_attack: 8, ordnance_attack: 6,
    speed: 26, acceleration: 4, maneuverability: 16, armor_class: 4, morale: 74,
    capacity: 400, description: '[Fragata Pesada] Bonus +2 naves no XWA; navio de linha mercenário'
  },
  {
    name: 'Marauder Corvette', acronym: 'MAR', factions: mand,
    credits: 500, producing_time: 0, hyperdrive: 1, shield: 900, hull: 580,
    laser_attack: 10, ion_attack: 0, ordnance_attack: 8,
    speed: 42, acceleration: 7, maneuverability: 28, armor_class: 3, morale: 62,
    capacity: 200, description: '[Corveta de Ataque] Bonus +1 nave no XWA; ataque rápido e fuga ágil'
  },
  {
    name: 'MC80A ChatNoir Cruiser', acronym: 'MC80A', factions: mand,
    credits: 1250, producing_time: 0, hyperdrive: 1, shield: 3200, hull: 1900,
    laser_attack: 30, ion_attack: 10, ordnance_attack: 6,
    speed: 22, acceleration: 4, maneuverability: 14, armor_class: 4, morale: 76,
    capacity: 600, description: '[Cruzador Pesado] Bonus +3 naves no XWA; nau capitânia mandaloriana'
  }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'CapitalShip',
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 100, influence_ratio: 10,
    groupable: false, carriable: false, armable: false, armory: true
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.3 LIGHT TRANSPORTS (type: 'LightTransport')
# ------------------------------------------------------------------------------
[
  {
    name: 'YT-1300', acronym: 'CORT', factions: all,
    credits: 100, shield: 120, hull: 76,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 8,
    speed: 88, acceleration: 7, maneuverability: 64, morale: 65,
    description: 'Cargueiro leve padrão (todas as facções)'
  },
  {
    name: 'Assault Transport', acronym: 'ATR', factions: all,
    credits: 125, shield: 200, hull: 142,
    laser_attack: 4, ion_attack: 2, ordnance_attack: 10,
    speed: 67, acceleration: 7, maneuverability: 52, morale: 70,
    description: 'Transporte tático de assalto multi-facção'
  },
  {
    name: 'Millennium Falcon', acronym: 'FALC', factions: reb,
    credits: 180, shield: 280, hull: 100,
    laser_attack: 3, ion_attack: 0, ordnance_attack: 8,
    speed: 102, acceleration: 13, maneuverability: 76, morale: 85,
    description: 'Cargueiro modificado de alta evasão Rebelde'
  },
  {
    name: 'System Patrol Craft', acronym: 'SPC', factions: emp,
    credits: 180, shield: 400, hull: 285,
    laser_attack: 7, ion_attack: 0, ordnance_attack: 8,
    speed: 78, acceleration: 13, maneuverability: 52, morale: 75,
    description: 'Nave de patrulha pesada Imperial'
  },
  {
    name: 'YT-2000', acronym: 'OTANA', factions: merc,
    credits: 200, shield: 320, hull: 114,
    laser_attack: 3, ion_attack: 1, ordnance_attack: 16,
    speed: 96, acceleration: 11, maneuverability: 69, morale: 70,
    description: 'Transporte armado pesado Mercenário'
  },
  {
    name: 'YT-2400', acronym: 'OUT', factions: mand,
    credits: 150, shield: 250, hull: 100,
    laser_attack: 3, ion_attack: 0, ordnance_attack: 12,
    speed: 102, acceleration: 13, maneuverability: 73, morale: 75,
    description: 'Cargueiro rápido Mandaloriano'
  }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'LightTransport',
    producing_time: 0, hyperdrive: 1, armor_class: 2,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 10, capacity: 200, influence_ratio: 1,
    groupable: true, carriable: false, armable: true, armory: false
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.4 FIGHTERS (types: 'Interceptor', 'Fighter', 'Bomber')
# ------------------------------------------------------------------------------
[
  # Rebel
  {
    name: 'A-Wing', acronym: 'A-W', type: 'Interceptor', factions: reb,
    credits: 120, hyperdrive: 1, shield: 50, hull: 14,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 12,
    speed: 120, acceleration: 21, maneuverability: 96, morale: 80,
    armable: true, description: 'Interceptador rebelde de alta velocidade'
  },
  {
    name: 'X-Wing', acronym: 'X-W', type: 'Fighter', factions: reb,
    credits: 80, hyperdrive: 1, shield: 50, hull: 20,
    laser_attack: 4, ion_attack: 0, ordnance_attack: 8,
    speed: 100, acceleration: 16, maneuverability: 75, morale: 80,
    armable: true, description: 'Caça principal multiuso equilibrado'
  },
  {
    name: 'Y-Wing', acronym: 'Y-W', type: 'Bomber', factions: reb,
    credits: 70, hyperdrive: 1, shield: 75, hull: 40,
    laser_attack: 2, ion_attack: 2, ordnance_attack: 12,
    speed: 80, acceleration: 11, maneuverability: 59, morale: 75,
    armable: true, description: 'Bombardeiro com canhões de íons'
  },
  # Empire
  {
    name: 'TIE Fighter*', acronym: 'T/F', type: 'Interceptor', factions: emp,
    credits: 20, hyperdrive: 0, shield: 0, hull: 9,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 0,
    speed: 100, acceleration: 20, maneuverability: 96, morale: 70,
    armable: false, description: 'Sem Hyperdrive/Warheads; enxame leve'
  },
  {
    name: 'TIE Interceptor*', acronym: 'T/I', type: 'Interceptor', factions: emp,
    credits: 30, hyperdrive: 0, shield: 0, hull: 16,
    laser_attack: 4, ion_attack: 0, ordnance_attack: 0,
    speed: 111, acceleration: 21, maneuverability: 104, morale: 75,
    armable: false, description: 'Sem Hyperdrive/Warheads; superioridade aérea'
  },
  {
    name: 'TIE Avenger', acronym: 'T/A', type: 'Fighter', factions: emp,
    credits: 110, hyperdrive: 1, shield: 40, hull: 14,
    laser_attack: 4, ion_attack: 0, ordnance_attack: 8,
    speed: 133, acceleration: 16, maneuverability: 104, morale: 85,
    armable: true, description: 'Caça multiuso de elite com escudo e hyperdrive'
  },
  {
    name: 'Assault Gunboat', acronym: 'GUN', type: 'Bomber', factions: emp,
    credits: 120, hyperdrive: 1, shield: 100, hull: 28,
    laser_attack: 2, ion_attack: 2, ordnance_attack: 16,
    speed: 90, acceleration: 20, maneuverability: 78, morale: 80,
    armable: true, description: 'Bombardeiro pesado imperial com íons'
  },
  # Mercenary
  {
    name: 'Z-95 Headhunter', acronym: 'Z-95', type: 'Interceptor', factions: merc,
    credits: 35, hyperdrive: 1, shield: 20, hull: 14,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 6,
    speed: 100, acceleration: 16, maneuverability: 86, morale: 65,
    armable: true, description: 'Caça leve ágil mercenário'
  },
  {
    name: 'R-41 Starchaser', acronym: 'R41', type: 'Fighter', factions: merc,
    credits: 65, hyperdrive: 1, shield: 30, hull: 14,
    laser_attack: 2, ion_attack: 2, ordnance_attack: 8,
    speed: 100, acceleration: 16, maneuverability: 75, morale: 70,
    armable: true, description: 'Caça multiuso versátil com lasers e íons'
  },
  {
    name: 'Skipray Blastboat', acronym: 'S/B', type: 'Bomber', factions: merc,
    credits: 105, hyperdrive: 1, shield: 102, hull: 61,
    laser_attack: 2, ion_attack: 3, ordnance_attack: 12,
    speed: 91, acceleration: 16, maneuverability: 64, morale: 75,
    armable: true, description: 'Bombardeiro/canhoneira pesada (6 torp + 6 mis)'
  },
  # Mandalorians
  {
    name: 'T-Wing', acronym: 'T-W', type: 'Interceptor', factions: mand,
    credits: 35, hyperdrive: 1, shield: 20, hull: 14,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 8,
    speed: 111, acceleration: 21, maneuverability: 78, morale: 75,
    armable: true, description: 'Interceptador rápido mandaloriano'
  },
  {
    name: 'Supa Fighter', acronym: 'SUP/F', type: 'Fighter', factions: mand,
    credits: 70, hyperdrive: 1, shield: 80, hull: 38,
    laser_attack: 2, ion_attack: 1, ordnance_attack: 8,
    speed: 89, acceleration: 16, maneuverability: 88, morale: 80,
    armable: true, description: 'Caça multiuso ágil e bem escudado'
  },
  {
    name: 'Firespray', acronym: 'FRS', type: 'Bomber', factions: mand,
    credits: 95, hyperdrive: 1, shield: 106, hull: 62,
    laser_attack: 2, ion_attack: 0, ordnance_attack: 10,
    speed: 91, acceleration: 16, maneuverability: 72, morale: 85,
    armable: true, description: 'Nave de assalto/bombardeiro mandaloriana'
  }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', producing_time: 0, armor_class: 1,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 10, capacity: 0, influence_ratio: 1,
    groupable: true, carriable: true, armory: false
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.5 ARMAMENTS (type: 'Armament')
# ------------------------------------------------------------------------------
[
  {
    name: 'Concussion Missiles', acronym: 'CM',
    credits: 5, ordnance_attack: 10, speed: 220, maneuverability: 60,
    description: '[Warhead/Ordnance] Míssil rápido ideal contra caças (1.0x)'
  },
  {
    name: 'Proton Torpedoes', acronym: 'PT',
    credits: 5, ordnance_attack: 15, speed: 110, maneuverability: 30,
    description: '[Warhead/Ordnance] Torpedo padrão contra capitais (1.5x)'
  },
  {
    name: 'Concussion Missiles + Chaff', acronym: 'CM+Chf',
    credits: 7, ordnance_attack: 10, speed: 220, maneuverability: 60,
    description: '[Warhead/Ordnance] Míssil rápido ideal contra caças (1.0x)'
  },
  {
    name: 'Proton Torpedoes + Chaff', acronym: 'PT+Chf',
    credits: 7, ordnance_attack: 15, speed: 110, maneuverability: 30,
    description: '[Warhead/Ordnance] Torpedo padrão contra capitais (1.5x)'
  },
  {
    name: 'Chaff', acronym: 'Chf',
    credits: 2, ordnance_attack: 0, speed: 0, maneuverability: 0,
    description: '[Countermeasure] Defesa contra mísseis guiados (+15 evasão)'
  }
].each do |data|
  seed_unit(all, {
    terrain: 'Space', type: 'Armament',
    producing_time: 0, hyperdrive: 0, shield: 0, hull: 0,
    laser_attack: 0, ion_attack: 0, acceleration: 0,
    armor_class: 1, morale: 100,
    siege_power: 0, force_power: 0, command_bonus: 0, rank: 0,
    weight: 0, capacity: 0, influence_ratio: 1,
    groupable: true, carriable: true, armable: false, armory: false
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.6 WARRIORS (type: 'Warrior')
# ------------------------------------------------------------------------------
[
  {
    name: 'Jedi Knight', acronym: 'JEDI', factions: reb,
    credits: 45, shield: 80, hull: 110,
    laser_attack: 18, ion_attack: 0, ordnance_attack: 0,
    speed: 60, acceleration: 15, maneuverability: 92, armor_class: 1, morale: 100,
    siege_power: 5, force_power: 85, command_bonus: 20, rank: 1,
    description: 'Inspiração: +20% moral/defesa às tropas aliadas'
  },
  {
    name: 'Sith Warrior', acronym: 'SITH', factions: emp,
    credits: 45, shield: 60, hull: 120,
    laser_attack: 24, ion_attack: 0, ordnance_attack: 0,
    speed: 62, acceleration: 15, maneuverability: 90, armor_class: 1, morale: 100,
    siege_power: 6, force_power: 90, command_bonus: 15, rank: 1,
    description: 'Terror: impõe -15 moral aos inimigos; letal em duelo'
  },
  {
    name: 'Dark Jedi', acronym: 'DJED', factions: merc,
    credits: 45, shield: 50, hull: 105,
    laser_attack: 21, ion_attack: 0, ordnance_attack: 2,
    speed: 60, acceleration: 15, maneuverability: 88, armor_class: 1, morale: 95,
    siege_power: 8, force_power: 65, command_bonus: 10, rank: 1,
    description: 'Sabotagem: desativa baterias e defesas planetárias'
  },
  {
    name: 'Mandalore Warrior', acronym: 'MAND', factions: mand,
    credits: 45, shield: 90, hull: 130,
    laser_attack: 14, ion_attack: 0, ordnance_attack: 10,
    speed: 65, acceleration: 16, maneuverability: 85, armor_class: 2, morale: 95,
    siege_power: 7, force_power: 0, command_bonus: 10, rank: 1,
    description: 'Armadura Beskar + Jetpack; caçador de Jedi e blindados'
  }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Ground', type: 'Warrior',
    producing_time: 0, hyperdrive: 0,
    weight: 1, capacity: 0, influence_ratio: 5,
    groupable: false, carriable: true, armable: false, armory: false
  }.merge(data))
end

# ==============================================================================
# 4. CONFIGURAÇÃO INICIAL DA PARTIDA & ADMIN
# ==============================================================================
Setup.create!(
  planet_income_ratio: 10,
  initial_credits: 12000,
  initial_planets: 2,
  initial_wormholes: 3,
  minimum_fleet_for_dominate: 12000,
  minimum_fleet_for_build: 1,
  builder_unit: 'CapitalShip',
  upgrade_cost: 1000,
  ai: true,
  ai_level: 4
)

AdminUser.create!(email: 'setup@xwsg.com', password: '123456', password_confirmation: '123456') if Rails.env.development?