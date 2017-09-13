class CreateSquads < ActiveRecord::Migration[5.1]
  def change
    create_table :squads do |t|
      t.string :name
      t.integer :faction
      t.integer :credits
      t.integer :metals
      t.integer :rare_elements
      t.string :url
      t.boolean :ready

      t.timestamps
    end
  end
end
