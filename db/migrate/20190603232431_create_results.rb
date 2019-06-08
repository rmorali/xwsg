class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
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
      t.integer :carrier_id
      t.integer :destination_id
      t.integer :arrives_in
      t.integer :ready_in
      t.string :description

      t.timestamps
    end
  end
end