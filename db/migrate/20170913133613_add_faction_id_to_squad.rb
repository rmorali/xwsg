class AddFactionIdToSquad < ActiveRecord::Migration[5.1]
  def change
    add_column :squads, :faction_id, :integer
  end
end
