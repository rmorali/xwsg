class AddRoundIdToFleets < ActiveRecord::Migration[5.1]
  def change
    add_column :fleets, :round_id, :integer
  end
end
