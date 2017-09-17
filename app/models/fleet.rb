class Fleet < ApplicationRecord
  scope :in_production, -> { joins(:unit).where('round_id + producing_time > ?', Round.get_current.number) }
  scope :terrain, lambda { |terrain| joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, lambda { |squad| where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round
  belongs_to :carrier, class_name: 'Fleet', foreign_key: 'carrier_id', optional: true
  belongs_to :destination, class_name: 'Planet', foreign_key: 'destination_id', optional: true

  delegate :name, to: :unit
  delegate :capacity, to: :unit

  def in_production?
    Round.get_current.number < self.round.number + self.unit.producing_time
  end

  def cargo
    Fleet.where(carrier: self)
  end

  def available_capacity
    loaded = 0
    self.cargo.each { |cargo| loaded += cargo.unit.weight * cargo.quantity }
    (self.capacity * self.quantity) - loaded
  end

  def weight
    self.quantity * self.unit.weight
  end

  def load_in(carrier,quantity)
    if self.unit.weight * quantity > carrier.available_capacity
      quantity = carrier.available_capacity  / self.unit.weight
      return nil if quantity < 1
    end
    if self.quantity == quantity
      self.update_attributes(carrier: carrier, destination: carrier.destination, arrives_in: carrier.arrives_in)
    else
      left_behind = self.dup
      left_behind.quantity = self.quantity - quantity
      left_behind.save
      self.update_attributes(quantity: quantity, carrier: carrier, destination: carrier.destination, arrives_in: carrier.arrives_in)
    end
  end

  def unload_from(carrier,quantity)
    if self.quantity == quantity
      self.update_attributes(carrier: nil, destination: nil, arrives_in: nil)
    else
      left_inside = self.dup
      left_inside.quantity = self.quantity - quantity
      left_inside.save
      self.update_attributes(quantity: quantity, carrier: nil, destination: nil, arrives_in: nil)
    end
  end

end
