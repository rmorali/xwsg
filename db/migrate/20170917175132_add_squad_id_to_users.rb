class AddSquadIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :squad_id, :integer
  end
end
