class AddArrivesInToFleets < ActiveRecord::Migration[5.1]
  def change
    add_column :fleets, :arrives_in, :integer
  end
end
