class Squad < ApplicationRecord

  has_many :fleets
  belongs_to :faction
  
end
