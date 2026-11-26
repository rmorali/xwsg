class BattleReport < ApplicationRecord
  belongs_to :round
  belongs_to :squad

  validates :squad_id, uniqueness: { scope: :round_id }
  validates :content, length: { maximum: 1500 }
end