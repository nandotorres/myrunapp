class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	  t.string				:provider,		:limit=> 50,	:null => false
	  t.string				:uid,			:limit=> 20,	:null => false
	  t.string				:name,			:limit=> 20,	:null => false	  
	  t.string				:last_name,		:limit=> 40
	  t.string				:email,			:limit=> 60,	:null => false
	  t.string				:image_url,		:limit=> 150
	  t.integer				:timezone,		:null => false,	:default => -3
	  t.string				:locale,		:limit => '6', 	:null => false,	:default => 'pt_BR'
	  t.string				:nikeplus_url
      t.timestamps
    end
	
	add_index :users, :uid, :unique => true
	add_index :users, :timezone
	
  end
end