class RemoveNameUsersIndexFromPantries < ActiveRecord::Migration
  def change
  	remove_index(:pantries, :name => "index_pantries_on_name_and_user_id")
  end
end
