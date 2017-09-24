class RenameLoadWeigthToWeightInUnits < ActiveRecord::Migration[5.1]
  def change
    rename_column :units, :load_weigth, :weight
  end
end
