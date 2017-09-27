class Fleet < ApplicationRecord
  scope :terrain, ->(terrain) { joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, ->(squad) { where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round
  belongs_to :carrier, class_name: 'Fleet', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true

  delegate :name, :facility?, :image, :hyperdrive, to: :unit

  def moving?
    true if destination
  end

  def movable?
    true if hyperdrive.to_i > 0
  end

  def in_production?
    Round.current.number < ready_in.to_i
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
    Fleet.where(planet: planet, squad: squad, destination: nil, carrier: nil).select { |fleet| fleet.unit.weight <= available_capacity }.reject { |fleet| fleet == self }
  end
end
