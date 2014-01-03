class CreatePantries < ActiveRecord::Migration
  def change
    create_table :pantries do |t|
      t.integer :user_id
      t.integer :ingredient_id

      t.timestamps
    end
    add_index :pantries, :user_id
    add_index :pantries, :ingredient_id
    add_index :pantries, [:user_id, :ingredient_id], unique: true
  end
end
