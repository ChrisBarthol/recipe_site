class AddRecipeIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :recipe_id, :integer
    add_index :comments, :recipe_id
  end
end
