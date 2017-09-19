class Squad < ApplicationRecord
  has_many :fleets
  belongs_to :faction
  has_many :users

  def debit_credits(value)
    update(credits: credits - value) unless value > credits
  end

  def debit_metals(value)
    update(metals: metals - value) unless value > metals
  end
end
