class CreateUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :units do |t|
      t.string :name
      t.string :acronym
      t.string :type
      t.string :terrain
      t.integer :faction_mask
      t.integer :hyperdrive
      t.integer :credits
      t.integer :metals
      t.integer :rare_elements
      t.integer :producing_time
      t.integer :influence
      t.integer :weight
      t.integer :capacity
      t.boolean :groupable
      t.boolean :carriable

      t.timestamps
    end
  end
end
