class CreateSquads < ActiveRecord::Migration[5.1]
  def change
    create_table :squads do |t|
      t.string :name
      t.integer :credits
      t.integer :metals
      t.integer :rare_elements
      t.integer :faction_id
      t.string :color
      t.string :url
      t.boolean :ready

      t.timestamps
    end
  end
end
