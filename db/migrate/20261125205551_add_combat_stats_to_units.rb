class AddCombatStatsToUnits < ActiveRecord::Migration[7.0]
  def change
    add_column :units, :laser_attack, :integer, default: 0, null: false
    add_column :units, :ion_attack, :integer, default: 0, null: false
    add_column :units, :ordnance_attack, :integer, default: 0, null: false
    add_column :units, :maneuverability, :integer, default: 0, null: false
    add_column :units, :speed, :integer, default: 0, null: false
    add_column :units, :armor_class, :integer, default: 1, null: false
  end
end