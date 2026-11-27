class AddNarrativeToRounds < ActiveRecord::Migration[8.1]
  def change
    add_column :rounds, :narrative, :text
  end
end
