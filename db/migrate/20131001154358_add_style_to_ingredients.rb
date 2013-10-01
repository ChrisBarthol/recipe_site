class AddStyleToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :style, :string
    add_index :ingredients, :style
  end
end
