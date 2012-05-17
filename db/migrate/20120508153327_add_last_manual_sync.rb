class AddLastManualSync < ActiveRecord::Migration
  def up
    change_table(:users) do |t|
	   t.datetime :last_manual_sync
	  end
  end

  def down
  end
end
