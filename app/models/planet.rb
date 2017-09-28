class Planet < ApplicationRecord
  serialize :domination, Hash
  has_many :fleets

  def image
    "planets/#{name.downcase}.png"
  end

  # TODO: Verify if a squad can build facilities, produce units etc
end
