class CreatePlanets < ActiveRecord::Migration[5.1]
  def change
    create_table :planets do |t|
      t.string :name
      t.string :sector
      t.integer :population, limit: 8
      t.integer :credits
      t.string :domination
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
