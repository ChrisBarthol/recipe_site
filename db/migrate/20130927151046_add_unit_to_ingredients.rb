class AddUnitToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :unit, :string
    add_index :ingredients, :unit
  end
end
