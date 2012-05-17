class AddLastRunningDay < ActiveRecord::Migration
  def up
	change_table(:users) do |t|
	  t.date :last_run_day
	end
	add_index :users, :last_run_day
  end

  def down
  end
end
