class Unit < ApplicationRecord

  self.inheritance_column = nil
  
  scope :allowed_for, lambda {|faction| where('faction_mask & ?', 2**Unit.factions.rindex(faction))}
  
  def self.factions
    %w[none rebel empire mercenary pirate]
  end
  
  def factions=(factions)
    factions = [factions] if factions.is_a? String
    self.faction_mask = (factions & Unit.factions).map { |r| 2**Unit.factions.index(r) }.sum
    save
  end

  def factions
    Unit.factions.reject do |r|
      ((self.faction_mask || 0) & 2**Unit.factions.index(r)).zero?
    end
  end
  
  def image
    "units/#{name.downcase}.png"
  end

end
