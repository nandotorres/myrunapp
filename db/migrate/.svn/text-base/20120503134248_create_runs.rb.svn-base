class CreateRuns < ActiveRecord::Migration
  def change
    create_table :runs do |t|
  	  t.references   :user
      t.datetime 	:start_time,	:null => false
  	  t.float	 	:distance, 		:null => false, :default => 0
  	  t.integer		:duration, 		:null => false, :default => 0
  	  t.datetime	:sync_time, 	:null => false
  	  t.float		:calories, 		:default => 0
  	  t.string		:name, 			:limit => 60
  	  t.string		:description, 	:limit => 150
  	  t.string		:how_felt,		:limit => 30
  	  t.string		:weather,		:limit => 30
  	  t.string		:terrain,		:limit => 30
  	  t.string		:intensity,		:limit => 30
  	  t.string		:equipmentType, :limit => 20, :default => 'iPod'
      t.timestamps
    end
    
	  add_index :runs,	:user_id
	  add_index :runs, 	:start_time
  end
end