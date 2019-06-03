class Combat < ApplicationRecord
  belongs_to :round
  belongs_to :unit
  belongs_to :fleet
  belongs_to :squad
  belongs_to :planet
  belongs_to :captor, class_name: 'Squad', foreign_key: 'captor_id', optional: true
end
