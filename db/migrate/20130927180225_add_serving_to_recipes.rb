class AddServingToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :serving, :integer
    add_column :recipes, :preptime, :string
    add_column :recipes, :totaltime, :string
    add_column :recipes, :nutrition, :string
    add_column :recipes, :rating, :integer
    add_index :recipes, :serving
    add_index :recipes, :preptime
    add_index :recipes, :totaltime
    add_index :recipes, :rating
  end
end
