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

  def in_production?
    Round.get_current.number < self.round.number + self.unit.producing_time
  end

  def moving?
    Round.get_current.number < self.round.number + Route.cost(self.planet,self.destination) if self.destination
  end

  def cargo
    Fleet.where(carrier: self)
  end

  def load_in(carrier,quantity)
    if self.quantity == quantity
      self.carrier = carrier
      self.save
    else
      left_behind = self.dup
      left_behind.quantity = self.quantity - quantity
      left_behind.save
      self.quantity = quantity
      self.carrier = carrier
      self.save
    end
  end

  def unload_from(carrier,quantity)
    if self.quantity == quantity
      self.carrier = nil
      self.save
    else
      left_inside = self.dup
      left_inside.quantity = self.quantity - quantity
      left_inside.save
      self.quantity = quantity
      self.carrier = nil
      self.save
    end

  end


end
