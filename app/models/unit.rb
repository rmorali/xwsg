class Unit < ApplicationRecord
  self.inheritance_column = nil
  has_many :fleets

  scope :allowed_for, ->(faction) { where('faction_mask & ?', 2**Faction.names.rindex(faction)) }

  def factions=(factions)
    factions = [factions] if factions.is_a? String
    self.faction_mask = (factions & Faction.names).map { |r| 2**Faction.names.index(r) }.sum
    save
  end

  def factions
    Faction.names.reject do |r|
      ((faction_mask || 0) & 2**Faction.names.index(r)).zero?
    end
  end

  def belongs?(faction)
    factions.include?(faction.name)
  end

  def image
    if (File.file?("units/#{ name.downcase }.png"))
      "units/#{ name.downcase }.png"
    else
      "units/all_ships.jpg"
    end
  end

  def facility?
    type == 'Facility'
  end

  def to_label
    "#{name}: #{credits} t#{producing_time}"
  end
end
