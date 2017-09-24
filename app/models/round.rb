class Round < ApplicationRecord
  enum phase: { strategy: 0, space_combat: 1, ground_combat: 2 }

  has_many :fleets

  def self.current
    Round.create if Round.count.zero?
    Round.last
  end

  def number
    id.to_i
  end
end
