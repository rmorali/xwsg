# frozen_string_literal: true

# ==============================================================================
# 1. FACÇÕES, SQUADS & USUÁRIO INICIAL
# ==============================================================================
Faction.create!([
  { name: 'Empire' },
  { name: 'Rebel' },
  { name: 'Mercenary' },
  { name: 'Pirate' }
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
# 3. CATÁLOGO DE UNIDADES (XWSG 1.7 ENXUTO + COMBATE TERRESTRE & RPG)
# ==============================================================================
emp       = ['Empire']
reb       = ['Rebel']
emp_reb   = %w[Empire Rebel]
merc      = ['Mercenary']
mand      = ['Pirate']
mand_merc = %w[Pirate Mercenary]
all       = %w[Empire Rebel Mercenary Pirate]

# Helper para criação limpa e atribuição de facções
def seed_unit(factions, attrs)
  unit = Unit.create!(attrs)
  unit.factions = factions
  unit
end

# ------------------------------------------------------------------------------
# 3.1 FACILITIES & DEFENSE SYSTEMS (Space)
# ------------------------------------------------------------------------------
[
  { name: 'Space Colony', acronym: 'SC/1', credits: 1200, shield: 1024, hull: 768, laser_attack: 0, ion_attack: 0, armor_class: 5, morale: 85, factions: all, description: 'Colônia orbital básica (600 pts produção)' },
  { name: 'Industrial Complex', acronym: 'INC', credits: 1800, shield: 2560, hull: 1216, laser_attack: 6, ion_attack: 6, armor_class: 5, morale: 90, factions: all, description: 'Complexo industrial armado (900 pts produção)' },
  { name: 'Shipyard', acronym: 'SHPYD', credits: 3600, shield: 9600, hull: 4560, laser_attack: 0, ion_attack: 0, armor_class: 5, morale: 95, factions: all, description: 'Estaleiro principal para naves capitais (1800 pts)' },
  { name: 'Golan I Defense Station', acronym: 'G/1', credits: 2400, shield: 3200, hull: 1520, laser_attack: 0, ion_attack: 19, armor_class: 5, morale: 100, factions: all, description: 'Estação orbital de defesa planetária' },
  { name: 'Golan III Fortress', acronym: 'G/3', credits: 3600, shield: 8000, hull: 3040, laser_attack: 2, ion_attack: 27, armor_class: 5, morale: 100, factions: emp_reb, description: 'Fortaleza orbital pesada' },
  { name: 'Pirate Asteroid Hangar', acronym: 'ASTHAN', credits: 2400, shield: 2560, hull: 2272, laser_attack: 12, ion_attack: 0, armor_class: 5, morale: 90, factions: mand_merc, description: 'Base oculta em asteroide' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'Facility', influence_ratio: 10, hyperdrive: 0,
    producing_time: 1, weight: 100, capacity: 100, groupable: false,
    carriable: false, armory: true
  }.merge(data))
end

[
  { name: 'Laser Battery', acronym: 'NL/B', credits: 100, shield: 200, hull: 95, laser_attack: 6, ion_attack: 0, armor_class: 2, description: 'Bateria orbital/planetária anti-caça' },
  { name: 'Ion Battery', acronym: 'NI/B', credits: 100, shield: 200, hull: 95, laser_attack: 0, ion_attack: 6, armor_class: 2, description: 'Bateria de íons anti-escudo' },
  { name: 'Space Minefield', acronym: 'MIN/C', credits: 150, shield: 0, hull: 1, laser_attack: 4, ion_attack: 0, ordnance_attack: 4, armor_class: 1, description: 'Campo minado com ogivas' }
].each do |data|
  seed_unit(all, {
    terrain: 'Space', type: 'DefenseSystem', influence_ratio: 1, hyperdrive: 0,
    producing_time: 0, weight: 10, capacity: 0, groupable: true,
    carriable: false, morale: 100
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.2 CAPITAL SHIPS (Enxutas + atributo Morale definindo fuga ou combate)
# ------------------------------------------------------------------------------
[
  # Compartilhadas
  { name: 'Corellian Corvette', acronym: 'CRV', credits: 300, producing_time: 0, shield: 640, hull: 400, laser_attack: 6, ion_attack: 0, ordnance_attack: 0, speed: 50, maneuverability: 32, armor_class: 3, morale: 65, capacity: 200, factions: all, description: 'Bonus +1 nave no XWA; recua se perder >40% Hull' },
  { name: 'Nebulon B Frigate', acronym: 'FRG', credits: 350, producing_time: 0, shield: 960, hull: 600, laser_attack: 12, ion_attack: 4, ordnance_attack: 0, speed: 35, maneuverability: 22, armor_class: 3, morale: 72, capacity: 200, factions: emp_reb, description: 'Bonus +1 nave no XWA; fragata de escolta padrão' },
  { name: 'Dreadnaught', acronym: 'DRD', credits: 900, producing_time: 0, shield: 2200, hull: 1500, laser_attack: 22, ion_attack: 4, ordnance_attack: 0, speed: 20, maneuverability: 12, armor_class: 4, morale: 75, capacity: 400, factions: mand_merc, description: 'Bonus +2 naves no XWA; cruzador robusto independente' },
  # Rebeldes
  { name: 'MC40A Light Cruiser', acronym: 'MC40A', credits: 650, producing_time: 0, shield: 1600, hull: 950, laser_attack: 16, ion_attack: 6, ordnance_attack: 8, speed: 32, maneuverability: 20, armor_class: 4, morale: 78, capacity: 400, factions: reb, description: 'Bonus +2 naves no XWA; cruzador rápido Rebelde' },
  { name: 'MC80 Liberty Cruiser', acronym: 'MC80L', credits: 1500, producing_time: 0, shield: 3800, hull: 2200, laser_attack: 36, ion_attack: 12, ordnance_attack: 6, speed: 22, maneuverability: 13, armor_class: 4, morale: 85, capacity: 600, factions: reb, description: 'Bonus +3 naves no XWA; linha de frente Rebelde' },
  { name: 'MC85A HomeOne Cruiser', acronym: 'MC85A', credits: 6000, producing_time: 2, shield: 9600, hull: 5400, laser_attack: 75, ion_attack: 25, ordnance_attack: 16, speed: 15, maneuverability: 8, armor_class: 5, morale: 95, capacity: 600, factions: reb, description: 'Bonus +3 naves no XWA; capitânia suprema Rebelde' },
  # Império
  { name: 'Lancer Frigate', acronym: 'LNC', credits: 400, producing_time: 0, shield: 800, hull: 520, laser_attack: 20, ion_attack: 0, ordnance_attack: 0, speed: 40, maneuverability: 25, armor_class: 3, morale: 75, capacity: 200, factions: emp, description: 'Bonus +1 nave no XWA; fragata anti-caça' },
  { name: 'Imperial Star Destroyer', acronym: 'ISD', credits: 1800, producing_time: 0, shield: 4400, hull: 2800, laser_attack: 44, ion_attack: 14, ordnance_attack: 8, speed: 18, maneuverability: 10, armor_class: 4, morale: 88, capacity: 600, factions: emp, description: 'Bonus +3 naves no XWA; pilar da frota Imperial' },
  { name: 'Interdictor', acronym: 'INT', credits: 2000, producing_time: 0, shield: 3400, hull: 2200, laser_attack: 24, ion_attack: 12, ordnance_attack: 0, speed: 20, maneuverability: 12, armor_class: 4, morale: 80, capacity: 600, factions: emp, description: 'Bonus +3 naves no XWA; bloqueia salto hiperespacial inimigo' },
  { name: 'Super Star Destroyer', acronym: 'SSD', credits: 7000, producing_time: 2, shield: 12000, hull: 7500, laser_attack: 95, ion_attack: 30, ordnance_attack: 24, speed: 12, maneuverability: 5, armor_class: 5, morale: 98, capacity: 600, factions: emp, description: 'Bonus +3 naves no XWA; dreadnought supremo Imperial' },
  # Mercenários
  { name: 'Radiant VII Light Cruiser', acronym: 'RCC', credits: 500, producing_time: 0, shield: 800, hull: 420, laser_attack: 8, ion_attack: 2, ordnance_attack: 0, speed: 27, maneuverability: 20, armor_class: 3, morale: 60, capacity: 200, factions: merc, description: 'Bonus +1 nave no XWA; recua cedo sob fogo pesado' },
  { name: 'Assault Frigate', acronym: 'AFRG', credits: 1150, producing_time: 0, shield: 2600, hull: 1650, laser_attack: 26, ion_attack: 8, ordnance_attack: 6, speed: 26, maneuverability: 16, armor_class: 4, morale: 74, capacity: 400, factions: merc, description: 'Bonus +2 naves no XWA; navio de linha mercenário' },
  # Piratas / Mandalorianos
  { name: 'Marauder Corvette', acronym: 'MAR', credits: 500, producing_time: 0, shield: 900, hull: 580, laser_attack: 10, ion_attack: 0, ordnance_attack: 8, speed: 42, maneuverability: 28, armor_class: 3, morale: 62, capacity: 200, factions: mand, description: 'Bonus +1 nave no XWA; ataque rápido e retirada ágil' },
  { name: 'MC80A ChatNoir Cruiser', acronym: 'MC80A', credits: 1250, producing_time: 0, shield: 3200, hull: 1900, laser_attack: 30, ion_attack: 10, ordnance_attack: 6, speed: 22, maneuverability: 14, armor_class: 4, morale: 76, capacity: 600, factions: mand, description: 'Bonus +3 naves no XWA; nau capitânia pirata/mandaloriana' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'CapitalShip', influence_ratio: 10, hyperdrive: 1,
    weight: 100, groupable: false, carriable: false, armory: true
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.3 LIGHT TRANSPORTS & HEAVY TRANSPORTS (Compartilhados + Exclusivos)
# ------------------------------------------------------------------------------
[
  { name: 'YT-1300', acronym: 'CORT', credits: 100, shield: 120, hull: 76, laser_attack: 2, ion_attack: 0, ordnance_attack: 8, speed: 88, acceleration: 7, maneuverability: 64, capacity: 200, factions: all, description: 'Cargueiro leve padrão (todas as facções)' },
  { name: 'Assault Transport', acronym: 'ATR', credits: 125, shield: 200, hull: 142, laser_attack: 4, ion_attack: 2, ordnance_attack: 10, speed: 67, acceleration: 7, maneuverability: 52, capacity: 200, factions: all, description: 'Transporte tático de assalto multi-facção' },
  { name: 'Millennium Falcon', acronym: 'FALC', credits: 180, shield: 280, hull: 100, laser_attack: 3, ion_attack: 0, ordnance_attack: 8, speed: 102, acceleration: 13, maneuverability: 76, capacity: 200, factions: reb, description: 'Cargueiro modificado de alta evasão Rebelde' },
  { name: 'System Patrol Craft', acronym: 'SPC', credits: 180, shield: 400, hull: 285, laser_attack: 7, ion_attack: 0, ordnance_attack: 8, speed: 78, acceleration: 13, maneuverability: 52, capacity: 200, factions: emp, description: 'Nave de patrulha pesada Imperial' },
  { name: 'YT-2000', acronym: 'OTANA', credits: 200, shield: 320, hull: 114, laser_attack: 3, ion_attack: 1, ordnance_attack: 16, speed: 96, acceleration: 11, maneuverability: 69, capacity: 200, factions: merc, description: 'Transporte armado pesado Mercenário' },
  { name: 'YT-2400', acronym: 'OUT', credits: 150, shield: 250, hull: 100, laser_attack: 3, ion_attack: 0, ordnance_attack: 12, speed: 102, acceleration: 13, maneuverability: 73, capacity: 200, factions: mand, description: 'Contrabandista/corsário Pirata' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'LightTransport', influence_ratio: 1, hyperdrive: 1,
    producing_time: 0, weight: 10, armor_class: 2, morale: 65,
    groupable: true, carriable: false, armable: true
  }.merge(data))
end

[
  { name: 'Container Transport', acronym: 'CTRNS', credits: 100, shield: 256, hull: 152, laser_attack: 3, ion_attack: 0, ordnance_attack: 0, speed: 33, acceleration: 5, maneuverability: 20, armor_class: 2, capacity: 200, armable: false, factions: all, description: 'Comboio logístico e transporte de fábricas' },
  { name: 'Rebel Med Transport', acronym: 'RMTRNS', credits: 95, shield: 240, hull: 160, laser_attack: 0, ion_attack: 0, ordnance_attack: 0, speed: 18, acceleration: 3, maneuverability: 16, armor_class: 2, capacity: 150, armable: false, factions: reb, description: 'Transporte de tropas/suprimentos GR-75 Rebelde' },
  { name: 'Star Galleon', acronym: 'STARG', credits: 190, shield: 320, hull: 228, laser_attack: 0, ion_attack: 9, ordnance_attack: 0, speed: 18, acceleration: 3, maneuverability: 15, armor_class: 3, capacity: 600, armable: false, factions: emp, description: 'Fragata pesada de transporte de tropas Imperial' },
  { name: 'Mobquet Transport', acronym: 'MOB', credits: 95, shield: 240, hull: 160, laser_attack: 0, ion_attack: 0, ordnance_attack: 0, speed: 16, acceleration: 3, maneuverability: 16, armor_class: 2, capacity: 150, armable: false, factions: merc, description: 'Cargueiro médio de tropas Mercenário' },
  { name: 'Suprosa', acronym: 'SUPRO', credits: 480, shield: 2240, hull: 168, laser_attack: 0, ion_attack: 2, ordnance_attack: 8, speed: 16, acceleration: 3, maneuverability: 20, armor_class: 3, capacity: 200, armable: true, factions: mand, description: 'Cargueiro blindado de alto escudo Pirata' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'HeavyTransport', influence_ratio: 1, hyperdrive: 1,
    producing_time: 0, weight: 20, morale: 60, groupable: true, carriable: false
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.4 FIGHTERS (Enxuto: Leve/Rápido, Multiuso e Bombardeiro por facção - 1 a 1)
# ------------------------------------------------------------------------------
[
  # Rebeldes
  { name: 'A-Wing', acronym: 'A-W', credits: 120, hyperdrive: 1, shield: 50, hull: 14, laser_attack: 2, ion_attack: 0, ordnance_attack: 12, speed: 120, acceleration: 21, maneuverability: 96, armable: true, factions: reb, description: 'Interceptador rebelde de alta velocidade' },
  { name: 'X-Wing', acronym: 'X-W', credits: 80, hyperdrive: 1, shield: 50, hull: 20, laser_attack: 4, ion_attack: 0, ordnance_attack: 8, speed: 100, acceleration: 16, maneuverability: 75, armable: true, factions: reb, description: 'Caça principal multiuso equilibrado' },
  { name: 'Y-Wing', acronym: 'Y-W', credits: 70, hyperdrive: 1, shield: 75, hull: 40, laser_attack: 2, ion_attack: 2, ordnance_attack: 12, speed: 80, acceleration: 11, maneuverability: 59, armable: true, factions: reb, description: 'Bombardeiro com canhões de íons' },
  # Império
  { name: 'Tie Fighter*', acronym: 'T/F', credits: 20, hyperdrive: 0, shield: 0, hull: 9, laser_attack: 2, ion_attack: 0, ordnance_attack: 0, speed: 100, acceleration: 20, maneuverability: 96, armable: false, factions: emp, description: 'Sem Hyperdrive/Warheads; enxame leve' },
  { name: 'Tie Interceptor*', acronym: 'T/I', credits: 30, hyperdrive: 0, shield: 0, hull: 16, laser_attack: 4, ion_attack: 0, ordnance_attack: 0, speed: 111, acceleration: 21, maneuverability: 104, armable: false, factions: emp, description: 'Sem Hyperdrive/Warheads; superioridade aérea' },
  { name: 'Tie Avenger', acronym: 'T/A', credits: 110, hyperdrive: 1, shield: 40, hull: 14, laser_attack: 4, ion_attack: 0, ordnance_attack: 8, speed: 133, acceleration: 16, maneuverability: 104, armable: true, factions: emp, description: 'Caça multiuso de elite com escudo e hyperdrive' },
  { name: 'Assault Gunboat', acronym: 'GUN', credits: 120, hyperdrive: 1, shield: 100, hull: 28, laser_attack: 2, ion_attack: 2, ordnance_attack: 16, speed: 90, acceleration: 20, maneuverability: 78, armable: true, factions: emp, description: 'Bombardeiro pesado imperial com íons' },
  # Mercenários
  { name: 'Z-95 Headhunter', acronym: 'Z-95', credits: 35, hyperdrive: 1, shield: 20, hull: 14, laser_attack: 2, ion_attack: 0, ordnance_attack: 6, speed: 100, acceleration: 16, maneuverability: 86, armable: true, factions: merc, description: 'Caça leve ágil mercenário' },
  { name: 'R-41 Starchaser', acronym: 'R41', credits: 65, hyperdrive: 1, shield: 30, hull: 14, laser_attack: 2, ion_attack: 2, ordnance_attack: 8, speed: 100, acceleration: 16, maneuverability: 75, armable: true, factions: merc, description: 'Caça multiuso versátil com lasers e íons' },
  { name: 'Skipray Blastboat', acronym: 'S/B', credits: 105, hyperdrive: 1, shield: 102, hull: 61, laser_attack: 2, ion_attack: 3, ordnance_attack: 12, speed: 91, acceleration: 16, maneuverability: 64, armable: true, factions: merc, description: 'Bombardeiro/canhoneira pesada (6 torp + 6 mis)' },
  # Piratas / Mandalorianos
  { name: 'T-Wing', acronym: 'T-W', credits: 35, hyperdrive: 1, shield: 20, hull: 14, laser_attack: 2, ion_attack: 0, ordnance_attack: 8, speed: 111, acceleration: 21, maneuverability: 78, armable: true, factions: mand, description: 'Interceptador leve pirata/mandaloriano' },
  { name: 'Supa Fighter', acronym: 'SUP/F', credits: 70, hyperdrive: 1, shield: 80, hull: 38, laser_attack: 2, ion_attack: 1, ordnance_attack: 8, speed: 89, acceleration: 16, maneuverability: 88, armable: true, factions: mand, description: 'Caça multiuso ágil e bem escudado' },
  { name: 'Firespray', acronym: 'FRS', credits: 95, hyperdrive: 1, shield: 106, hull: 62, laser_attack: 2, ion_attack: 0, ordnance_attack: 10, speed: 91, acceleration: 16, maneuverability: 72, armable: true, factions: mand, description: 'Nave de assalto/bombardeiro mandaloriana' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Space', type: 'Fighter', influence_ratio: 1, producing_time: 0,
    weight: 10, capacity: 0, armor_class: 1, morale: 75,
    groupable: true, carriable: true
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.5 ARMAMENTS & CAPITAL UPGRADES (XWSG 1.7)
# ------------------------------------------------------------------------------
[
  { name: 'Concussion Missiles', acronym: 'CM', credits: 5, speed: 220, maneuverability: 60, ordnance_attack: 10, description: 'Míssil rápido ideal contra caças (1.0x)' },
  { name: 'Proton Torpedoes', acronym: 'PT', credits: 5, speed: 110, maneuverability: 30, ordnance_attack: 15, description: 'Torpedo padrão contra naves capitais (1.5x)' },
  { name: 'Ion Pulse Torpedoes', acronym: 'IPT', credits: 5, speed: 130, maneuverability: 55, ion_attack: 20, description: 'Drena escudos e desabilita sistemas (2.0x)' },
  { name: 'Mag Pulse Torpedoes', acronym: 'MPT', credits: 10, speed: 260, maneuverability: 85, ion_attack: 15, description: 'Desliga armas laser do alvo' },
  { name: 'Heavy Rockets', acronym: 'HR', credits: 15, speed: 45, maneuverability: 15, ordnance_attack: 100, description: 'Foguete pesado contra estações e capitais (10.0x)' },
  { name: 'Chaff', acronym: 'Chaff', credits: 2, speed: 0, maneuverability: 15, description: 'Contramedida contra mísseis guiados (+15 evasão)' },
  { name: 'Flare', acronym: 'Flare', credits: 10, speed: 0, maneuverability: 30, description: 'Contramedida avançada contra warheads (+30 evasão)' }
].each do |data|
  seed_unit(all, {
    terrain: 'Space', type: 'Armament', influence_ratio: 1, hyperdrive: 0,
    producing_time: 0, weight: 0, capacity: 0, armor_class: 1, morale: 100,
    groupable: true, carriable: true
  }.merge(data))
end

[
  { name: 'Super Radar', acronym: 'SAR', credits: 150, description: 'Detecta grandes unidades e exércitos nos planetas próximos' },
  { name: 'Anti-Trooper Bombs', acronym: 'ATB', credits: 150, description: 'Bombardeia e destrói até 50% das Tropas inimigas' },
  { name: 'Enhanced Engine', acronym: 'ENG', credits: 300, description: 'Permite hiperespaço em todos os planetas de um mesmo setor' },
  { name: 'Gravity Interdictor', acronym: 'INT', credits: 600, description: 'Transforma a Capital Ship em um Interdictor' }
].each do |data|
  seed_unit(all, {
    terrain: 'Space', type: 'Upgrade', influence_ratio: 1, hyperdrive: 0,
    producing_time: 0, weight: 0, capacity: 0, armor_class: 1, morale: 100,
    groupable: false, carriable: true
  }.merge(data))
end

# ------------------------------------------------------------------------------
# 3.6 GROUND ARMIES & JEDI/SITH/INDEPENDENT WARRIORS (Risk/War + RPG)
# ------------------------------------------------------------------------------
[
  { name: 'Trooper', acronym: 'TRP', credits: 1, weight: 1, shield: 0, hull: 10, laser_attack: 2, ordnance_attack: 0, armor_class: 1, maneuverability: 45, speed: 20, morale: 60, siege_power: 2, factions: all, description: 'Infantaria básica; ocupação planetária (Risk)' },
  { name: 'Heavy Weapons Squad', acronym: 'HWS', credits: 3, weight: 1, shield: 0, hull: 12, laser_attack: 1, ordnance_attack: 4, armor_class: 1, maneuverability: 40, speed: 18, morale: 65, siege_power: 4, factions: all, description: 'Especialista antiveículo e anti-bateria' },
  { name: 'Speeder Bike', acronym: 'SPD', credits: 8, weight: 2, shield: 0, hull: 20, laser_attack: 4, ordnance_attack: 0, armor_class: 2, maneuverability: 82, speed: 75, morale: 70, siege_power: 2, factions: all, description: 'Reconhecimento, flanco e perseguição' },
  { name: 'AT-ST Walker', acronym: 'AT-ST', credits: 25, weight: 5, shield: 0, hull: 85, laser_attack: 10, ordnance_attack: 4, armor_class: 3, maneuverability: 35, speed: 35, morale: 80, siege_power: 8, factions: merc + emp, description: 'Apoio blindado médio anti-infantaria' },
  { name: 'T2-B Repulsor Tank', acronym: 'T2-B', credits: 25, weight: 5, shield: 40, hull: 65, laser_attack: 9, ordnance_attack: 4, armor_class: 3, maneuverability: 45, speed: 45, morale: 80, siege_power: 8, factions: reb + mand, description: 'Tanque flutuante com escudo leve' },
  { name: 'AT-AT Heavy Walker', acronym: 'AT-AT', credits: 90, weight: 15, shield: 0, hull: 260, laser_attack: 18, ordnance_attack: 12, armor_class: 4, maneuverability: 10, speed: 15, morale: 95, siege_power: 25, command_bonus: 5, factions: emp, description: 'Fortaleza móvel; resiste a bombardeio orbital' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Ground', type: 'GroundArmy', influence_ratio: 1, hyperdrive: 0,
    producing_time: 0, capacity: 0, groupable: true, carriable: true
  }.merge(data))
end

[
  { name: 'Jedi Knight', acronym: 'JEDI', credits: 45, shield: 80, hull: 110, laser_attack: 18, ordnance_attack: 0, armor_class: 1, maneuverability: 92, speed: 60, morale: 100, siege_power: 5, force_power: 85, command_bonus: 20, rank: 1, factions: reb, description: 'Inspiração: +20% moral/defesa às tropas aliadas' },
  { name: 'Sith Warrior', acronym: 'SITH', credits: 45, shield: 60, hull: 120, laser_attack: 24, ordnance_attack: 0, armor_class: 1, maneuverability: 90, speed: 62, morale: 100, siege_power: 6, force_power: 90, command_bonus: 15, rank: 1, factions: emp, description: 'Terror: impõe -15 moral aos inimigos; letal em duelo' },
  { name: 'Dark Jedi', acronym: 'DJED', credits: 45, shield: 50, hull: 105, laser_attack: 21, ordnance_attack: 2, armor_class: 1, maneuverability: 88, speed: 60, morale: 95, siege_power: 8, force_power: 65, command_bonus: 10, rank: 1, factions: merc, description: 'Sabotagem: desativa baterias e defesas planetárias' },
  { name: 'Mandalore Warrior', acronym: 'MAND', credits: 45, shield: 90, hull: 130, laser_attack: 14, ordnance_attack: 10, armor_class: 2, maneuverability: 85, speed: 65, morale: 95, siege_power: 7, force_power: 0, command_bonus: 10, rank: 1, factions: mand, description: 'Armadura Beskar + Jetpack; caçador de Jedi e blindados' }
].each do |data|
  factions = data.delete(:factions)
  seed_unit(factions, {
    terrain: 'Ground', type: 'Warrior', influence_ratio: 5, hyperdrive: 0,
    producing_time: 0, weight: 1, capacity: 0, groupable: false, carriable: true
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