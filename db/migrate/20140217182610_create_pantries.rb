class CreatePantries < ActiveRecord::Migration
  def change
    create_table :pantries do |t|
      t.string :name
      t.string :quantity
      t.string :unit
      t.integer :user_id

      t.timestamps
    end
    add_index :pantries, [:name, :user_id], unique: true
    add_index :pantries, :quantity
    add_index :pantries, :unit
  end
end
