class ChangeUsers < ActiveRecord::Migration
  def up
	change_table(:users) do |t|
		t.boolean :speed_in_km, :null => false, :default => true
		t.boolean :distance_in_km, :null => false, :default => true
	end
  end

  def down
  end
end
