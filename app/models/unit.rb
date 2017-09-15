class Unit < ApplicationRecord

  self.inheritance_column = nil
  has_many :fleets

  scope :allowed_for, lambda {|faction| where('faction_mask & ?', 2**Faction.names.rindex(faction))}

  def factions=(factions)
    factions = [factions] if factions.is_a? String
    self.faction_mask = (factions & Faction.names).map { |r| 2**Faction.names.index(r) }.sum
    save
  end

  def factions
    Faction.names.reject do |r|
      ((self.faction_mask || 0) & 2**Faction.names.index(r)).zero?
    end
  end

  def belongs?(faction)
    self.factions.include?(faction.name)
  end

  def image
    "units/#{name.downcase}.png"
  end

end
