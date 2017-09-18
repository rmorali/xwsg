class Squad < ApplicationRecord
  has_many :fleets
  belongs_to :faction
  has_many :users

  def debit(value, type)
    if type == 'credits'
      update_attributes(credits: credits - value) unless value > credits
    else
      update_attributes(metals: metals - value) unless value > metals
    end
  end
end
