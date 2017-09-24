class AddCarrierIdToFleets < ActiveRecord::Migration[5.1]
  def change
    add_column :fleets, :carrier_id, :integer
  end
end
