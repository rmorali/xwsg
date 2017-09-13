class Round < ApplicationRecord
  enum phase: { strategy: 0, space_combat: 1, ground_combat: 2 }

  has_many :fleets

  def self.get_current
      Round.create if Round.count == 0
      Round.last
  end

  def number
    self.id.to_i
  end
end
