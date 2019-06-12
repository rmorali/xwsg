class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.integer :vector_a
      t.integer :vector_b
      t.integer :distance
      t.boolean :wormhole

      t.timestamps
    end
  end
end
