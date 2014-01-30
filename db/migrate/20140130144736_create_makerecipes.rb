class CreateMakerecipes < ActiveRecord::Migration
  def change
    create_table :makerecipes do |t|
      t.integer :maker_id
      t.integer :made_id

      t.timestamps
    end
    add_index :makerecipes, :maker_id
    add_index :makerecipes, :made_id
  end
end
