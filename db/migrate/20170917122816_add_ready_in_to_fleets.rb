class AddReadyInToFleets < ActiveRecord::Migration[5.1]
  def change
    add_column :fleets, :ready_in, :integer
  end
end
