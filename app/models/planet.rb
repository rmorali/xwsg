class Planet < ApplicationRecord
  serialize :domination, Hash
  has_many :fleets

  def image
    "planets/#{name.downcase}.png"
  end


  def under_attack?
    return true if fleets.distinct.count('squad_id') > 1
 end
  # TODO: Verify if a squad can build facilities, produce units etc
end
