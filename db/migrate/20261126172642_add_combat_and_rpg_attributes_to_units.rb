# frozen_string_literal: true

class AddCombatAndRpgAttributesToUnits < ActiveRecord::Migration[7.0]
  def change
    change_table :units, bulk: true do |t|
      # Atributos de combate espacial & blindagem
      t.integer :acceleration, default: 0, null: false

      # Atributos de moral (Capital Ships & Exércitos), cerco (Risk/War) e RPG (Heróis)
      t.integer :morale, default: 75, null: false
      t.integer :siege_power, default: 0, null: false
      t.integer :force_power, default: 0, null: false
      t.integer :command_bonus, default: 0, null: false
      t.integer :rank, default: 0, null: false
    end
  end
end