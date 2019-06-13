class CreateFleets < ActiveRecord::Migration[5.1]
  def change
    create_table :fleets do |t|
      t.integer :quantity
      t.references :unit, foreign_key: true
      t.references :squad, foreign_key: true
      t.references :planet, foreign_key: true
      t.integer :round_id
      t.integer :carrier_id
      t.integer :arrives_in
      t.integer :ready_in
      t.integer :destination_id
      t.integer :armament_id
      t.integer :level
      t.string :description
      t.boolean :ai
      t.timestamps
    end
  end
end
