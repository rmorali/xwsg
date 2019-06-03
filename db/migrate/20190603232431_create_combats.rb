class CreateCombats < ActiveRecord::Migration[5.1]
  def change
    create_table :combats do |t|
      t.integer :round_id
      t.integer :unit_id
      t.integer :fleet_id
      t.integer :squad_id
      t.integer :planet_id
      t.integer :quantity
      t.integer :blasted
      t.integer :fled
      t.integer :captured
      t.integer :captor_id
      t.integer :final_quantity
      t.boolean :blocked
      t.boolean :moving

      t.timestamps
    end
  end
end
