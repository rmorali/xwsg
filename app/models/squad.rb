class Squad < ApplicationRecord
  has_many :fleets
  belongs_to :faction
  has_many :users

  def debit_credits(value)
    update(credits: credits - value) if value <= credits
  end

  def debit_metals(value)
    update(metals: metals - value) if value <= metals
  end
end
