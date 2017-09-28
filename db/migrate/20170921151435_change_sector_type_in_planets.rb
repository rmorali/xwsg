class ChangeSectorTypeInPlanets < ActiveRecord::Migration[5.1]
  def change
    change_column :planets, :sector, :integer
  end
end
