class CreateReciperelationships < ActiveRecord::Migration
  def change
    create_table :reciperelationships do |t|
      t.integer :recipesaver_id
      t.integer :recipesaved_id

      t.timestamps
    end
    add_index :reciperelationships, :recipesaver_id
    add_index :reciperelationships, :recipesaved_id
    add_index :reciperelationships, [:recipesaver_id, :recipesaved_id], unique: true
  end
end
