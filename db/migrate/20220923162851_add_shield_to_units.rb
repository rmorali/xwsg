class AddShieldToUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :units, :shield, :integer
  end
end
