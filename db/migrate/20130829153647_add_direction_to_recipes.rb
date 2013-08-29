class AddDirectionToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :direction, :text
    add_column :recipes, :fork_id, :integer
  end
end
