class AddRecipeimageToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :recipeimage, :string
  end
end
