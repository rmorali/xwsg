class AddDestinationIdToFleets < ActiveRecord::Migration[5.1]
  def change
    add_column :fleets, :destination_id, :integer
  end
end
