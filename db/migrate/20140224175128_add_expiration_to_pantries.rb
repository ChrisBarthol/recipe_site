class AddExpirationToPantries < ActiveRecord::Migration
  def change
  	add_column :pantries, :expiration, :date
  	add_index :pantries, :expiration
  end
end
