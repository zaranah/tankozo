class CreateRastaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :rastaurants do |t|
      t.string :nickname,       null: false
      t.integer :prefecture_id, null: false
      t.string :station,        null: false
      t.integer :genre_id,      null: false
      t.string :food,           null: false
      t.integer :price_id,      null: false
      t.text :opinion,          null: false
      t.references :user,       null: false, foreign_key: true
      t.timestamps
    end
  end
end
