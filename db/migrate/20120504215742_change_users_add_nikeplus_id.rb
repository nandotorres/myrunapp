class ChangeUsersAddNikeplusId < ActiveRecord::Migration
  def up
	change_table :users do |t|
	  t.integer :nikeplus_id, :null => false, :default => 0
	  t.string  :screen_name, :limit => 30
	end	
	add_index :users, :nikeplus_id
  end

  def down
  end
end
