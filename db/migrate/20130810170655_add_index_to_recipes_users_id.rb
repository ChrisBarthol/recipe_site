class AddIndexToRecipesUsersId < ActiveRecord::Migration
  def change
  	add_index :recipes, :user_id
  end
end
