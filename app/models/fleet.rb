class Fleet < ApplicationRecord
  scope :operational, -> { joins(:unit).where('round_id + producing_time <= ?', Round.get_current.number) }

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round

end
