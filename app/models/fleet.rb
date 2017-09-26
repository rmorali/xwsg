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

  def embark(quantity, fleet)
    return nil if quantity < 1
    if fleet.weight > available_capacity
      quantity = (available_capacity / fleet.unit.weight).round
      return nil if quantity < 1
    end
    if fleet.quantity == quantity
      fleet.update(carrier: self, destination: destination, arrives_in: arrives_in)
    else
      left_behind = fleet.dup
      left_behind.quantity = fleet.quantity - quantity
      left_behind.save
      fleet.update(quantity: quantity, carrier: self, destination: destination, arrives_in: arrives_in)
    end
  end

  def disembark(quantity, fleet)
    return nil if quantity < 1
    if fleet.quantity == quantity
      fleet.update(carrier: nil, destination: nil, arrives_in: nil)
    else
      left_inside = fleet.dup
      left_inside.quantity = fleet.quantity - quantity
      left_inside.save
      fleet.update(quantity: quantity, carrier: nil, destination: nil, arrives_in: nil)
    end
  end

  def embarkables
    Fleet.where(planet: planet, squad: squad, destination: nil, carrier: nil).select { |fleet| fleet.unit.weight <= available_capacity }.reject { |fleet| fleet == self }
  end
end
