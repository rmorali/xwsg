class Faction < ApplicationRecord

  has_many :squads

  def self.names
    names = []
    Faction.all.each { |f| names << f.name }
    names
  end  

end
