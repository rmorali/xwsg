class Fleet < ApplicationRecord
  scope :in_production, -> { joins(:unit).where('round_id + producing_time > ?', Round.get_current.number) }
  scope :terrain, lambda { |terrain| joins(:unit).where('terrain = ?', terrain) }
  scope :enemy_of, lambda { |squad| where('squad_id != ?', squad) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round

  def in_production?
    Round.get_current.number < self.round.number + self.unit.producing_time
  end

end
