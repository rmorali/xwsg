# ==============================================================================
# 1. FACTIONS, INITIAL SQUAD & ADMIN USER
# ==============================================================================
Faction.create!([
  { name: 'Empire' },
  { name: 'Rebel' },
  { name: 'Mercenary' },
  { name: 'Pirate' }
])

empire_faction = Faction.find_by!(name: 'Empire')
bot_squad = Squad.create!(
  name: 'BOT Empire',
  color: '#00FF00',
  faction: empire_faction,
  ai: true,
  ai_level: 4
)

User.create!(email: 'setup@xwsg.com', password: '123456', squad: bot_squad)

# ==============================================================================
# 2. GALAXY MAP: PLANETS & HYPERSPACE ROUTES
# ==============================================================================
planets_data = [
  { key: :bespin,       name: 'Bespin',       sector: 1, x: 363,  y: 475 },
  { key: :bonadan,      name: 'Bonadan',      sector: 2, x: 1488, y: 475 },
  { key: :concord_dawn, name: 'Concord Dawn', sector: 2, x: 925,  y: 250 },
  { key: :corellia,     name: 'Corellia',     sector: 2, x: 813,  y: 475 },
  { key: :coruscant,    name: 'Coruscant',    sector: 1, x: 475,  y: 250 },
  { key: :dagobah,      name: 'Dagobah',      sector: 3, x: 475,  y: 1150 },
  { key: :deathstar,    name: 'Death Star',   sector: 1, x: 700,  y: 250 },
  { key: :endor,        name: 'Endor',        sector: 3, x: 250,  y: 700 },
  { key: :felucia,      name: 'Felucia',      sector: 2, x: 1150, y: 250 },
  { key: :geonosis,     name: 'Geonosis',     sector: 4, x: 813,  y: 925 },
  { key: :haruun_kal,   name: 'Haruun Kal',   sector: 4, x: 700,  y: 700 },
  { key: :hoth,         name: 'Hoth',         sector: 3, x: 475,  y: 700 },
  { key: :ilum,         name: 'Ilum',         sector: 1, x: 250,  y: 250 },
  { key: :kamino,       name: 'Kamino',       sector: 4, x: 1375, y: 700 },
  { key: :kashyyyk,     name: 'Kashyyyk',     sector: 2, x: 1263, y: 475 },
  { key: :kessel,       name: 'Kessel',       sector: 2, x: 1038, y: 475 },
  { key: :kuat,         name: 'Kuat',         sector: 4, x: 925,  y: 700 },
  { key: :mandalore,    name: 'Mandalore',    sector: 1, x: 588,  y: 475 },
  { key: :mon_calamari, name: 'Mon Calamari', sector: 2, x: 1375, y: 250 },
  { key: :mustafar,     name: 'Mustafar',     sector: 3, x: 138,  y: 925 },
  { key: :mygeeto,      name: 'Mygeeto',      sector: 1, x: 588,  y: 25 },
  { key: :naboo,        name: 'Naboo',        sector: 3, x: 588,  y: 925 },
  { key: :nal_hutta,    name: 'Nal Hutta',    sector: 4, x: 1150, y: 700 },
  { key: :ord_ibanna,   name: 'Ord Ibanna',   sector: 3, x: 363,  y: 925 },
  { key: :polis_massa,  name: 'Polis Massa',  sector: 3, x: 25,   y: 700 },
  { key: :rattatak,     name: 'Rattatak',     sector: 1, x: 138,  y: 475 },
  { key: :rhen_var,     name: 'Rhen Var',     sector: 2, x: 1038, y: 25 },
  { key: :ryloth,       name: 'Ryloth',       sector: 4, x: 925,  y: 1150 },
  { key: :tatooine,     name: 'Tatooine',     sector: 4, x: 1038, y: 925 },
  { key: :utapau,       name: 'Utapau',       sector: 3, x: 700,  y: 1150 },
  { key: :yavin,        name: 'Yavin',        sector: 1, x: 813,  y: 25 }
]

planets = planets_data.each_with_object({}) do |p, hash|
  hash[p[:key]] = Planet.create!(name: p[:name], sector: p[:sector], x: p[:x], y: p[:y], credits: 0)
end

route_pairs = [
  [:mygeeto, :yavin], [:mygeeto, :deathstar], [:mygeeto, :coruscant],
  [:yavin, :rhen_var], [:yavin, :deathstar], [:yavin, :concord_dawn],
  [:rhen_var, :felucia], [:rhen_var, :concord_dawn],
  [:deathstar, :coruscant],
  [:coruscant, :mandalore], [:coruscant, :bespin],
  [:corellia, :concord_dawn], [:corellia, :kuat], [:corellia, :deathstar], [:corellia, :haruun_kal],
  [:mandalore, :corellia], [:mandalore, :deathstar],
  [:concord_dawn, :felucia], [:concord_dawn, :kessel], [:concord_dawn, :deathstar],
  [:felucia, :mon_calamari], [:felucia, :kashyyyk], [:felucia, :kessel],
  [:mon_calamari, :bonadan], [:mon_calamari, :kashyyyk],
  [:endor, :bespin], [:endor, :hoth], [:endor, :rattatak], [:endor, :ord_ibanna], [:endor, :polis_massa],
  [:rattatak, :polis_massa],
  [:bespin, :rattatak], [:bespin, :mandalore], [:bespin, :hoth],
  [:kuat, :kessel], [:kuat, :nal_hutta], [:kuat, :tatooine], [:kuat, :geonosis],
  [:kessel, :kashyyyk], [:kessel, :nal_hutta], [:kessel, :corellia],
  [:kashyyyk, :bonadan], [:kashyyyk, :kamino], [:kashyyyk, :nal_hutta],
  [:ilum, :rattatak], [:ilum, :coruscant], [:ilum, :bespin],
  [:hoth, :haruun_kal], [:hoth, :ord_ibanna], [:hoth, :mandalore], [:hoth, :naboo],
  [:haruun_kal, :naboo], [:haruun_kal, :mandalore], [:haruun_kal, :geonosis], [:haruun_kal, :kuat],
  [:nal_hutta, :kamino], [:nal_hutta, :tatooine],
  [:bonadan, :kamino],
  [:mustafar, :endor], [:mustafar, :polis_massa], [:mustafar, :ord_ibanna],
  [:ord_ibanna, :naboo], [:ord_ibanna, :dagobah],
  [:naboo, :geonosis], [:naboo, :utapau], [:naboo, :dagobah],
  [:geonosis, :tatooine], [:geonosis, :ryloth], [:geonosis, :utapau],
  [:dagobah, :utapau],
  [:utapau, :ryloth],
  [:ryloth, :tatooine]
]

Route.create!(
  route_pairs.map { |a, b| { vector_a: planets.fetch(a), vector_b: planets.fetch(b), distance: 1 } }
)

# ==============================================================================
# 3. UNITS (XWSG - EXPERIMENTAL SPECS)
# ==============================================================================
EMP       = ['Empire'].freeze
REB       = ['Rebel'].freeze
EMP_REB   = ['Empire', 'Rebel'].freeze
MERC      = ['Mercenary'].freeze
MAND      = ['Pirate'].freeze
MAND_MERC = ['Pirate', 'Mercenary'].freeze
ALL       = %w[Empire Rebel Mercenary Pirate].freeze

def create_unit!(attrs, factions)
  unit = Unit.create!(attrs)
  unit.factions = factions
  unit
end

# ------------------------------------------------------------------------------
# 3.1 FACILITIES (Armor Class: 5)
# ------------------------------------------------------------------------------
facilities = [
  { name: 'Platforms',       credits: 1800, shield: 2560, hull: 1216, laser_attack: 12, ion_attack: 0, ordnance_attack: 0, factions: EMP_REB },
  { name: 'Asteroid Hangar', credits: 2400, shield: 2560, hull: 2272, laser_attack: 12, ion_attack: 0, ordnance_attack: 0, factions: MAND_MERC },
  { name: 'Rebel Platform',  credits: 2400, shield: 3200, hull: 1824, laser_attack: 8,  ion_attack: 0, ordnance_attack: 0, factions: REB },
  { name: 'Golan I',         credits: 2400, shield: 3200, hull: 1520, laser_attack: 19, ion_attack: 0, ordnance_attack: 0, factions: ALL }
]

facilities.each do |spec|
  create_unit!(
    {
      name: spec[:name],
      type: 'Facility',
      terrain: 'Space',
      credits: spec[:credits],
      influence_ratio: 10,
      hyperdrive: 0,
      producing_time: 1,
      weight: 100,
      capacity: 100,
      groupable: false,
      carriable: false,
      armory: true,
      shield: spec[:shield],
      hull: spec[:hull],
      laser_attack: spec[:laser_attack],
      ion_attack: spec[:ion_attack],
      ordnance_attack: spec[:ordnance_attack],
      maneuverability: 0,
      speed: 0,
      armor_class: 5
    },
    spec[:factions]
  )
end

# ------------------------------------------------------------------------------
# 3.2 CAPITAL SHIPS (Armor Class: 3 = Corvettes/Frigates, 4 = Cruisers/SDs, 5 = SSD)
# ------------------------------------------------------------------------------
capital_ships = [
  # Corvettes & Frigates (Armor Class 3)
  { name: 'Corellian Gunship',   credits: 300,  capacity: 200, shield: 600,  hull: 350,  laser_attack: 8,  ion_attack: 0, ordnance_attack: 8,  maneuverability: 35, speed: 55, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: EMP_REB },
  { name: 'Corellian Corvette',  credits: 300,  capacity: 200, shield: 640,  hull: 400,  laser_attack: 6,  ion_attack: 0, ordnance_attack: 0,  maneuverability: 32, speed: 50, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: REB },
  { name: 'Mod Corvette',        credits: 300,  capacity: 200, shield: 700,  hull: 420,  laser_attack: 8,  ion_attack: 2, ordnance_attack: 4,  maneuverability: 30, speed: 48, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: MAND_MERC },
  { name: 'Nebulon B Frigate',   credits: 350,  capacity: 200, shield: 960,  hull: 600,  laser_attack: 12, ion_attack: 4, ordnance_attack: 0,  maneuverability: 22, speed: 35, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: EMP_REB },
  { name: 'Mod Nebulon Frigate', credits: 400,  capacity: 200, shield: 1100, hull: 680,  laser_attack: 14, ion_attack: 4, ordnance_attack: 4,  maneuverability: 22, speed: 35, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: MAND_MERC },
  { name: 'Carrack Cruiser',     credits: 350,  capacity: 200, shield: 960,  hull: 640,  laser_attack: 14, ion_attack: 4, ordnance_attack: 0,  maneuverability: 26, speed: 45, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: EMP },
  { name: 'Lancer Frigate',      credits: 400,  capacity: 200, shield: 800,  hull: 520,  laser_attack: 20, ion_attack: 0, ordnance_attack: 0,  maneuverability: 25, speed: 40, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: EMP },
  { name: 'Marauder Corvette',   credits: 500,  capacity: 200, shield: 900,  hull: 580,  laser_attack: 10, ion_attack: 0, ordnance_attack: 8,  maneuverability: 28, speed: 42, armor_class: 3, desc: 'Bonus +1 nave simultanea no XWA', factions: MAND_MERC },
  { name: 'Escort Carrier',      credits: 500,  capacity: 400, shield: 1280, hull: 800,  laser_attack: 8,  ion_attack: 2, ordnance_attack: 0,  maneuverability: 18, speed: 28, armor_class: 3, desc: 'Bonus +2 naves simultaneas no XWA', factions: EMP },

  # Cruisers & Star Destroyers (Armor Class 4)
  { name: 'MC40A Light Cruiser',   credits: 650,  capacity: 400, shield: 1600, hull: 950,  laser_attack: 16, ion_attack: 6,  ordnance_attack: 8,  maneuverability: 20, speed: 32, armor_class: 4, desc: 'Bonus +2 naves simultaneas no XWA', factions: REB },
  { name: 'Bulk Cruiser',          credits: 750,  capacity: 400, shield: 1800, hull: 1200, laser_attack: 18, ion_attack: 4,  ordnance_attack: 0,  maneuverability: 15, speed: 24, armor_class: 4, desc: 'Bonus +2 naves simultaneas no XWA', factions: MAND_MERC },
  { name: 'Strike Cruiser',        credits: 800,  capacity: 400, shield: 2000, hull: 1300, laser_attack: 20, ion_attack: 6,  ordnance_attack: 4,  maneuverability: 16, speed: 26, armor_class: 4, desc: 'Bonus +2 naves simultaneas no XWA', factions: REB },
  { name: 'Dreadnaught',           credits: 900,  capacity: 400, shield: 2200, hull: 1500, laser_attack: 22, ion_attack: 4,  ordnance_attack: 0,  maneuverability: 12, speed: 20, armor_class: 4, desc: 'Bonus +2 naves simultaneas no XWA', factions: MAND_MERC },
  { name: 'Assault Frigate',       credits: 1150, capacity: 400, shield: 2600, hull: 1650, laser_attack: 26, ion_attack: 8,  ordnance_attack: 6,  maneuverability: 16, speed: 26, armor_class: 4, desc: 'Bonus +2 naves simultaneas no XWA', factions: REB },
  { name: 'Mod Strike Cruiser',    credits: 1150, capacity: 600, shield: 2600, hull: 1700, laser_attack: 28, ion_attack: 8,  ordnance_attack: 8,  maneuverability: 15, speed: 25, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: MAND_MERC },
  { name: 'MC80A ChatNoir Cruiser',credits: 1250, capacity: 600, shield: 3200, hull: 1900, laser_attack: 30, ion_attack: 10, ordnance_attack: 6,  maneuverability: 14, speed: 22, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: MAND_MERC },
  { name: 'Victory SD',            credits: 1250, capacity: 600, shield: 3000, hull: 2100, laser_attack: 32, ion_attack: 8,  ordnance_attack: 12, maneuverability: 12, speed: 20, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: EMP },
  { name: 'MC80 ReefHome Cruiser', credits: 1500, capacity: 600, shield: 3800, hull: 2200, laser_attack: 34, ion_attack: 12, ordnance_attack: 6,  maneuverability: 13, speed: 22, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: REB },
  { name: 'MC80 Liberty Cruiser',  credits: 1500, capacity: 600, shield: 3800, hull: 2200, laser_attack: 36, ion_attack: 12, ordnance_attack: 6,  maneuverability: 13, speed: 22, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: REB },
  { name: 'Imperial SD',           credits: 1800, capacity: 600, shield: 4400, hull: 2800, laser_attack: 44, ion_attack: 14, ordnance_attack: 8,  maneuverability: 10, speed: 18, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: EMP },
  { name: 'Interdictor',           credits: 2000, capacity: 600, shield: 3400, hull: 2200, laser_attack: 24, ion_attack: 12, ordnance_attack: 0,  maneuverability: 12, speed: 20, armor_class: 4, desc: 'Bonus +3 naves simultaneas no XWA', factions: EMP },

  # Dreadnoughts / Command Ships (Armor Class 5)
  { name: 'MC85A HomeOne Cruiser', credits: 6000, producing_time: 2, capacity: 600, shield: 9600,  hull: 5400, laser_attack: 75, ion_attack: 25, ordnance_attack: 16, maneuverability: 8, speed: 15, armor_class: 5, desc: 'Bonus +3 naves simultaneas no XWA', factions: REB },
  { name: 'Super StarDestroyer',   credits: 7000, producing_time: 2, capacity: 600, shield: 12000, hull: 7500, laser_attack: 95, ion_attack: 30, ordnance_attack: 24, maneuverability: 5, speed: 12, armor_class: 5, desc: 'Bonus +3 naves simultaneas no XWA', factions: EMP }
]

capital_ships.each do |spec|
  create_unit!(
    {
      name: spec[:name],
      type: 'CapitalShip',
      terrain: 'Space',
      credits: spec[:credits],
      influence_ratio: 10,
      hyperdrive: 1,
      producing_time: spec.fetch(:producing_time, 0),
      weight: 100,
      capacity: spec[:capacity],
      groupable: false,
      carriable: false,
      armory: true,
      description: spec[:desc],
      shield: spec[:shield],
      hull: spec[:hull],
      laser_attack: spec[:laser_attack],
      ion_attack: spec[:ion_attack],
      ordnance_attack: spec[:ordnance_attack],
      maneuverability: spec[:maneuverability],
      speed: spec[:speed],
      armor_class: spec[:armor_class]
    },
    spec[:factions]
  )
end

# ------------------------------------------------------------------------------
# 3.3 LIGHT TRANSPORTS (XWSG Experimental | Armor Class: 2)
# ------------------------------------------------------------------------------
light_transports = [
  { name: 'YT-2000',          credits: 200, ordnance: 16, laser: 3, ion: 1, shield: 320, hull: 114, speed: 96,  maneuver: 69, factions: MAND_MERC },
  { name: 'YT-2400',          credits: 150, ordnance: 12, laser: 3, ion: 0, shield: 250, hull: 100, speed: 102, maneuver: 73, factions: MAND },
  { name: 'Millenium Falcon', credits: 180, ordnance: 8,  laser: 3, ion: 0, shield: 280, hull: 100, speed: 102, maneuver: 76, factions: REB },
  { name: 'System Pat Craft', credits: 180, ordnance: 8,  laser: 7, ion: 0, shield: 400, hull: 285, speed: 78,  maneuver: 52, factions: EMP }
]

light_transports.each do |spec|
  create_unit!(
    {
      name: spec[:name],
      type: 'LightTransport',
      terrain: 'Space',
      credits: spec[:credits],
      influence_ratio: 1,
      hyperdrive: 1,
      producing_time: 0,
      weight: 10,
      capacity: 40,
      groupable: true,
      carriable: false,
      armable: true,
      shield: spec[:shield],
      hull: spec[:hull],
      laser_attack: spec[:laser],
      ion_attack: spec[:ion],
      ordnance_attack: spec[:ordnance],
      maneuverability: spec[:maneuver],
      speed: spec[:speed],
      armor_class: 2
    },
    spec[:factions]
  )
end

# ------------------------------------------------------------------------------
# 3.4 FIGHTERS (XWSG Experimental | Armor Class: 1)
# ------------------------------------------------------------------------------
fighters = [
  { name: 'Y-Wing',            credits: 210, hyperdrive: 1, ordnance: 12, laser: 2, ion: 2, shield: 225, hull: 120, speed: 80,  maneuver: 59,  factions: REB },
  { name: 'X-Wing',            credits: 240, hyperdrive: 1, ordnance: 8,  laser: 4, ion: 0, shield: 150, hull: 60,  speed: 100, maneuver: 75,  factions: REB },
  { name: 'A-Wing',            credits: 360, hyperdrive: 1, ordnance: 12, laser: 2, ion: 0, shield: 150, hull: 42,  speed: 120, maneuver: 96,  factions: REB },
  { name: 'Planetary Fighter', credits: 165, hyperdrive: 1, ordnance: 6,  laser: 2, ion: 0, shield: 120, hull: 42,  speed: 138, maneuver: 78,  factions: MERC },
  { name: 'Razor Fighter',     credits: 210, hyperdrive: 1, ordnance: 8,  laser: 2, ion: 2, shield: 114, hull: 60,  speed: 98,  maneuver: 86,  factions: MERC },
  { name: 'Skipray Blastboat', credits: 315, hyperdrive: 1, ordnance: 12, laser: 2, ion: 3, shield: 306, hull: 183, speed: 91,  maneuver: 64,  factions: MERC },
  { name: 'Preybird Fighter',  credits: 150, hyperdrive: 1, ordnance: 8,  laser: 2, ion: 0, shield: 138, hull: 54,  speed: 100, maneuver: 86,  factions: MAND },
  { name: 'Supa Fighter',      credits: 210, hyperdrive: 1, ordnance: 8,  laser: 2, ion: 1, shield: 240, hull: 114, speed: 89,  maneuver: 88,  factions: MAND },
  { name: 'Pursuer',           credits: 240, hyperdrive: 1, ordnance: 8,  laser: 2, ion: 1, shield: 300, hull: 180, speed: 95,  maneuver: 67,  factions: MAND },
  { name: 'Firespray',         credits: 285, hyperdrive: 1, ordnance: 10, laser: 2, ion: 0, shield: 318, hull: 186, speed: 91,  maneuver: 72,  factions: MAND },
  { name: 'Tie Fighter*',      credits: 60,  hyperdrive: 0, ordnance: 0,  laser: 2, ion: 0, shield: 50,  hull: 27,  speed: 100, maneuver: 96,  armable: false, desc: 'Sem Hyperdrive/Warheads', factions: EMP },
  { name: 'Tie Bomber*',       credits: 75,  hyperdrive: 0, ordnance: 8,  laser: 2, ion: 0, shield: 50,  hull: 84,  speed: 80,  maneuver: 86,  armable: true,  desc: 'Sem Hyperdrive',          factions: EMP },
  { name: 'Tie Interceptor*',  credits: 90,  hyperdrive: 0, ordnance: 0,  laser: 4, ion: 0, shield: 50,  hull: 48,  speed: 111, maneuver: 104, armable: false, desc: 'Sem Hyperdrive/Warheads', factions: EMP },
  { name: 'Assault Gunboat',   credits: 360, hyperdrive: 1, ordnance: 16, laser: 2, ion: 2, shield: 300, hull: 84,  speed: 90,  maneuver: 78,  factions: EMP }
]

fighters.each do |spec|
  create_unit!(
    {
      name: spec[:name],
      type: 'Fighter',
      terrain: 'Space',
      credits: spec[:credits],
      influence_ratio: 1,
      hyperdrive: spec[:hyperdrive],
      producing_time: 0,
      weight: 10,
      capacity: 0,
      groupable: true,
      carriable: true,
      armable: spec.fetch(:armable, true),
      description: spec[:desc],
      shield: spec[:shield],
      hull: spec[:hull],
      laser_attack: spec[:laser],
      ion_attack: spec[:ion],
      ordnance_attack: spec[:ordnance],
      maneuverability: spec[:maneuver],
      speed: spec[:speed],
      armor_class: 1
    },
    spec[:factions]
  )
end

# ------------------------------------------------------------------------------
# 3.5 ARMAMENTS (Warheads & Countermeasures)
# ------------------------------------------------------------------------------
armaments = [
  { name: 'Missile',                acronym: 'M',        credits: 5,  ordnance: 10, speed: 220, maneuver: 50 },
  { name: 'Missile + Chaff',        acronym: 'M+Chaff',  credits: 7,  ordnance: 10, speed: 220, maneuver: 65 },
  { name: 'Missile + Flare',        acronym: 'M+Flare',  credits: 15, ordnance: 10, speed: 220, maneuver: 80 },
  { name: 'Proton Torpedo',         acronym: 'PT',       credits: 5,  ordnance: 15, speed: 110, maneuver: 30 },
  { name: 'Proton Torpedo + Chaff', acronym: 'PT+Chaff', credits: 7,  ordnance: 15, speed: 110, maneuver: 45 },
  { name: 'Proton Torpedo + Flare', acronym: 'PT+Flare', credits: 15, ordnance: 15, speed: 110, maneuver: 60 }
]

armaments.each do |spec|
  create_unit!(
    {
      name: spec[:name],
      acronym: spec[:acronym],
      type: 'Armament',
      terrain: 'Space',
      credits: spec[:credits],
      influence_ratio: 1,
      hyperdrive: 0,
      producing_time: 0,
      weight: 0,
      capacity: 0,
      groupable: true,
      carriable: true,
      shield: 0,
      hull: 0,
      laser_attack: 0,
      ion_attack: 0,
      ordnance_attack: spec[:ordnance],
      maneuverability: spec[:maneuver],
      speed: spec[:speed],
      armor_class: 1
    },
    ALL
  )
end

# ==============================================================================
# 4. GAME SETUP & DEVELOPMENT ADMIN
# ==============================================================================
Setup.create!(
  planet_income_ratio: 10,
  initial_credits: 12_000,
  initial_planets: 2,
  initial_wormholes: 3,
  minimum_fleet_for_dominate: 12_000,
  minimum_fleet_for_build: 1,
  builder_unit: 'CapitalShip',
  upgrade_cost: 1000,
  ai: true,
  ai_level: 4
)

if Rails.env.development?
  AdminUser.create!(email: 'setup@xwsg.com', password: '123456', password_confirmation: '123456')
end