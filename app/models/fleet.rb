class Fleet < ApplicationRecord
  scope :terrain, ->(terrain) { joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, ->(squad) { where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round
  belongs_to :carrier, class_name: 'Fleet', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true
  has_many :results

  delegate :name, :facility?, :image, :hyperdrive, :groupable, :carriable, to: :unit

  after_save :destroy_if_empty

  def moving?
    true if destination
  end

  def movable?
    true if hyperdrive.to_i > 0
  end

  def in_production?
    ready_in.to_i > 0
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

  def weight
    quantity * unit.weight
  end

  def carriables
    fleets = Fleet.where(planet: planet, squad: squad, destination: nil, carrier: nil)
    lighter = fleets.select { |fleet| fleet.unit.weight <= available_capacity && fleet.carriable }
    lighter.reject { |fleet| fleet == self }
  end

  def destroy_if_empty
    destroy if quantity == 0
  end
end
