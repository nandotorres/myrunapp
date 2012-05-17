class AddNikeplusRunIdToRuns < ActiveRecord::Migration
  def change
    change_table(:runs) do |t|
	  t.integer :nikeplus_run_id
	end
  end
end
