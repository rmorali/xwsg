class CreateSetups < ActiveRecord::Migration[5.1]
  def change
    create_table :setups do |t|
      t.integer :planet_income_ratio
      t.integer :initial_credits
      t.integer :initial_planets
      t.integer :initial_wormholes
      t.integer :minimum_fleet_for_dominate
      t.integer :minimum_fleet_for_build
      t.string :builder_unit
      t.integer :upgrade_cost
      t.boolean :ai
      t.integer :ai_level
    end
  end
end
