class Fleet < ApplicationRecord

  belongs_to :unit
  belongs_to :squad
  belongs_to :planet
  belongs_to :round

end
