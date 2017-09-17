class AddColorToSquads < ActiveRecord::Migration[5.1]
  def change
    add_column :squads, :color, :string
  end
end
