class AddScheduleToUser < ActiveRecord::Migration
  def change
	change_table(:users) do |t|
	  #morning, afternoon, evening, night
	  t.string :usual_time, :null => false, :default => :morning
    end
  end
end
