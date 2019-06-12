class Fleet < ApplicationRecord
  scope :terrain, ->(terrain) { joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, ->(squad) { where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round
  belongs_to :carrier, class_name: 'Fleet', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true
  belongs_to :armament, class_name: 'Unit', foreign_key: 'armament_id', optional: true
  has_many :results

  delegate :name, :credits, :type, :influence_ratio, :facility?, :image,
           :hyperdrive, :groupable, :carriable, :armable, :armory, :producing_time, to: :unit

  after_save :destroy_if_empty

  def radar?
    level >= 3 && type == 'CapitalShip'
  end

  def visible_by_radar?
    true if type == 'Facility' || type == 'CapitalShip' || type == 'Trooper'
  end

  def loadable?
    true if capacity.to_i > 0
  end

  def builder?
    @setup = Setup.current
    ability = nil
    ability = true if type == 'Facility'
    ability = true if type == @setup.builder_unit && quantity >= @setup.minimum_fleet_for_build
    ability = false if moving? || in_production?
    ability
  end

  def moving?
    true if destination
  end

  def movable?
    true unless hyperdrive.to_i < 1 || in_production?
  end

  def in_production?
    ready_in.to_i > 0
  end

  def production_status
    100 / (ready_in + 1)
  end

  def cargo
    Fleet.where(carrier: self)
  end

  def capacity
    quantity * unit.capacity
  end

  def available_capacity
    loaded = 0
    cargo.each { |cargo| loaded += cargo.weight }
    capacity - loaded
  end

  def used_capacity
    capacity - available_capacity
  end

  def weight
    quantity * unit.weight
  end

  def carriables
    fleets = Fleet.where(planet: planet, squad: squad, destination: nil, carrier: nil)
    lighter = fleets.select { |fleet| fleet.unit.weight <= available_capacity && fleet.carriable }
    lighter.reject { |fleet| fleet == self }
  end

  def influence
    fleet_influence = quantity * credits * influence_ratio
  end

  def destroy_if_empty
    destroy if quantity == 0
  end
end
