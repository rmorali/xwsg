class CreateFleets < ActiveRecord::Migration[5.1]
  def change
    create_table :fleets do |t|
      t.integer :quantity
      t.references :unit, foreign_key: true
      t.references :squad, foreign_key: true
      t.references :planet, foreign_key: true
      t.string :description
      t.timestamps
    end
  end
end
