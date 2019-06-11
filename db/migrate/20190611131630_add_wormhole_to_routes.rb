class AddWormholeToRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :routes, :wormhole, :boolean
  end
end
