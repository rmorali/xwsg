class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.string :name
      t.string :acronym
      t.string :type
      t.string :terrain
      t.integer :faction_mask
      t.integer :hyperdrive, default: 0
      t.integer :credits
      t.integer :producing_time
      t.integer :influence_ratio
      t.integer :weight
      t.integer :capacity
      t.boolean :groupable
      t.boolean :carriable
      t.boolean :armable
      t.boolean :armory
      t.string :description

      t.timestamps
    end
  end
end
