class Squad < ApplicationRecord

  has_many :fleets
  belongs_to :faction
  has_many :users

  def debit(value,type)
    if type == 'credits'
      self.update_attributes(credits: self.credits - value) unless value > self.credits
    else
      self.update_attributes(metals: self.metals - value) unless value > self.metals
    end
  end

end
