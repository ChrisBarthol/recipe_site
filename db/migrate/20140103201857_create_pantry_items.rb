class CreatePantryItems < ActiveRecord::Migration
  def change
    create_table :pantry_items do |t|
      t.integer :user_id
      t.integer :ingredient_id

      t.timestamps
    end
    add_index :pantry_items, :user_id
    add_index :pantry_items, :ingredient_id
    add_index :pantry_items, [:user_id, :ingredient_id], unique: true
  end
end
