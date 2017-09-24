class RenameLoadCapacityToCapacityInUnits < ActiveRecord::Migration[5.1]
  def change
    rename_column :units, :load_capacity, :capacity
  end
end
