class CreateShoppingLists < ActiveRecord::Migration
  def change
    create_table :shopping_lists do |t|
      t.integer :user_id
      t.string :name
      t.string :quantity
      t.string :unit
      t.string :style

      t.timestamps
    end
  end
end
