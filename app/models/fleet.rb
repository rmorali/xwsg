class Fleet < ApplicationRecord
  scope :terrain, ->(terrain) { joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, ->(squad) { where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round
  belongs_to :carrier, class_name: 'Fleet', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true

  delegate :name, :facility?, to: :unit

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

  def load_in(carrier, quantity)
    if unit.weight * quantity > carrier.available_capacity
      quantity = carrier.available_capacity / unit.weight
      return nil if quantity < 1
    end
    if self.quantity == quantity
      update(carrier: carrier, destination: carrier.destination, arrives_in: carrier.arrives_in)
    else
      left_behind = dup
      left_behind.quantity = self.quantity - quantity
      left_behind.save
      update(quantity: quantity, carrier: carrier, destination: carrier.destination, arrives_in: carrier.arrives_in)
    end
  end

  def unload_from(carrier, quantity)
    if self.quantity == quantity
      update(carrier: nil, destination: nil, arrives_in: nil)
    else
      left_inside = dup
      left_inside.quantity = self.quantity - quantity
      left_inside.save
      update(quantity: quantity, carrier: nil, destination: nil, arrives_in: nil)
    end
  end
end
