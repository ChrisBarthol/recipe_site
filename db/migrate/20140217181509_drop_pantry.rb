class DropPantry < ActiveRecord::Migration
  def change
  	drop_table :pantries
  end
end
