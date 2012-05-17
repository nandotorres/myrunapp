# -*- coding: utf-8 -*-

require "rubygems"
require "time"

namespace :batch do  
  
  desc "Collect data from users"  
  
  task :collect => :environment do
  
  	@threads = []
  	
  	total = 0
    today = Time.now.utc.strftime('%Y-%m-%d')
  
  	log("Searching for users still pending for today")
  	gmt_6hs, gmt_23hs = get_time_zone_range
  	
    users = User.find(
        :all,
        :conditions => "nikeplus_id <> 0 AND last_run_day IS NULL OR last_run_day < CAST('#{today}' AS DATE) AND timezone BETWEEN #{gmt_6hs} AND #{gmt_23hs}"
    )
  	
  	users.each do |user|
  	
  	  while(all_threads_called? && has_thread_alive?)
  		sleep(1)
  	  end
  	  
  	  index = available_index
  	  
  	  @threads[index] = Thread.new { 
  		  log("Collect for #{user.full_name} (#{user.nikeplus_id})")
  		  run_data = user.parse_xml_last_run
  		  last_run_day = Time.iso8601(run_data[:startTime].to_s)
  		  if last_run_day.strftime('%Y-%m-%d').to_s != user.last_run_day.to_s
  		    if Run.find_by_nikeplus_run_id(run_data[:nikeplus_run_id]).nil?
    			  run = Run.new
    			  run.nikeplus_run_id = run_data[:nikeplus_run_id]
    			  run.start_time      = Time.iso8601(run_data[:startTime]) 
    			  run.distance        = run_data[:distance]
    			  run.duration        = run_data[:duration]
    			  run.calories        = run_data[:calories]
    			  run.name            = run_data[:name]
    			  run.description     = run_data[:description]
    			  run.how_felt        = run_data[:howFelt]
    			  run.weather         = run_data[:weather]
    			  run.terrain         = run_data[:terrain]
    			  run.intensity       = run_data[:intensity]
    			  run.equipmentType   = run_data[:equipmentType]
    			  run.sync_time       = Time.iso8601(run_data[:syncTime])
    			  run.user_id         = user.id
    			  run.save
    		    user.last_run_day   = Time.iso8601(run_data[:syncTime])
    			  user.save
    			  user.post_to_facebook(run.id)
    			  total = total + 1
    			  log("Run stored")
  			  end
  		  end 
  	  }
  	  
  	  @threads[index].join()
  	  
  	end
  	
  	log("Finished. Collected data for #{total} users")
	
  end
  
  task :test_timezone => :environment do
    puts get_time_zone_range        
  end
  
  task :test_screenshot => :environment do 
    kit = IMGKit.new('http://google.com')
  end
  
  def get_time_zone_range
    diff     = 6 - Time.now.utc.hour
    gmt_6hs  = (diff >= -14) ? diff : Time.now.utc.hour - 12
    gmt_23hs = ((gmt_6hs - 7) > -12) ? gmt_6hs - 7 : gmt_6hs + 17
    [gmt_6hs , gmt_23hs]
  end
  
  def available_index
	  index = 0
	  @threads.each do |t|
	    index = index + 1
	    return index if t.nil? || !t.alive?
	  end
	  index
  end
  
  def all_threads_called?
	  return @threads.count < 6
  end
  
  def has_thread_alive?
	  @threads.each do |t|
	    return true if t.alive?	
	  end
	  false
  end
  
  def log(msg)
	  puts(Time.now.strftime("%Y-%m-%d %H:%M:%S #{msg}"))
  end
  
end