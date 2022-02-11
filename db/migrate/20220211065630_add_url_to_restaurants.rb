class AddUrlToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :restaurant_url, :text
  end
end
