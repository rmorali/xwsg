class Round < ApplicationRecord
  enum phase: { strategy: 0, space_combat: 1, finished: 2 }

  has_many :fleets
  has_many :results

  def self.current
    Round.create if Round.count.zero?
    Round.last
  end

  def number
    id.to_i
  end

  def next_phase!
    if strategy?
      space_combat!
    else
      finished!
    end
    Round.create if finished?
  end
end
