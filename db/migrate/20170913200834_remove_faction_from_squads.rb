class RemoveFactionFromSquads < ActiveRecord::Migration[5.1]
  def change
    remove_column :squads, :faction, :integer
  end
end
