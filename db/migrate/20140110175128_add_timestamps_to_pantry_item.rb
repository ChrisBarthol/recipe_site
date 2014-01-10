class AddTimestampsToPantryItem < ActiveRecord::Migration
  def change_table
  	add_column(:pantry_items, :created_at, :datetime)
  	add_column(:pantry_items, :updated_at, :datetime)
  end
end
