class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :ranking
      t.integer :user_id
      t.integer :recipe_id

      t.timestamps
    end
    add_index :ratings, [:ranking, :user_id]
    add_index :ratings, [:ranking, :recipe_id]
  end
end
