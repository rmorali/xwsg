class Round < ApplicationRecord
  # enum phase: { strategy: 0, space_combat: 1, ground_combat: 2, finished: 3 }

  has_many :fleets

  def self.current
    Round.create if Round.count.zero?
    Round.last
  end

  def number
    id.to_i
  end

  def next_phase!
    increment!(:phase, 1)
    Round.create if phase > 3
  end
end
