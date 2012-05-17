module MyRunAppAPI

  require 'net/http'
  require 'rexml/document'
  
  class Nikeplus
  
	PUBLIC_RUN_LIST_URL = "http://nikeplus.nike.com/nikeplus/v1/services/widget/get_public_run_list.jsp?userID="
	USER_DATA_URL       = "http://nikerunning.nike.com/nikeplus/v2/services/app/get_user_data.jsp?_plus=true&userID="
	XPATHS = {
		:user_data => [
			['screenName', 'plusService/userOptions/screenName'],
			['avatar', 'plusService/userOptions/avatar'],
			['powerSongArtist', 'plusService/userOptions/powerSong/artist'],
			['powerSongTitle', 'plusService/userOptions/powerSong/title'],
			['totalDistance', 'plusService/userTotals/totalDistance'],			
		],
		:last_run => [
			['startTime', 'plusService/runList/run[last()]/startTime'],
			['distance', 'plusService/runList/run[last()]/distance'],
			['duration', 'plusService/runList/run[last()]/duration'],
			['syncTime', 'plusService/runList/run[last()]/syncTime'],
			['calories', 'plusService/runList/run[last()]/calories'],
			['name', 'plusService/runList/run[last()]/name'],
			['description', 'plusService/runList/run[last()]/description'],
			['howFelt', 'plusService/runList/run[last()]/howFelt'],
			['weather', 'plusService/runList/run[last()]/weather'],
			['terrain', 'plusService/runList/run[last()]/terrain'],
			['intensity', 'plusService/runList/run[last()]/intensity'],			
			['equipmentType', 'plusService/runList/run[last()]/equipmentType']			
		]
	}
    
    def extract_user_id_from_url(url)
	  return 0 if (url =~ /^(http[s]?:\/\/)?nikerunning\.nike\.com/).nil?
	  @nikeplus_user_id = url.scan(/\/history\/([0-9]{1,})\//).join("") || 0
	end	

	def request_url(url)
	  uri = URI(url)
	  res = Net::HTTP.get_response(uri)
      Net::HTTP.start(uri.host, uri.port) do |http|
        request  = Net::HTTP::Get.new uri.request_uri
        response = http.request request
		return "" if (response.code.to_i != 200)
		return response.body
      end
	end
	
	def parse_xml_user_data(uid)
	  buffer = request_url(URI.parse(USER_DATA_URL + uid.to_s))
	  user_data = {}
	  doc = REXML::Document.new(buffer)
	  XPATHS[:user_data].each do |item|
		  doc.elements.each(item[1]) do |ele|
		    user_data[item[0].to_sym] = ele.text
		  end
	  end
	  user_data
	end
	
	def parse_xml_last_run(uid)
	  buffer = request_url(URI.parse(PUBLIC_RUN_LIST_URL + uid.to_s))
	  doc = REXML::Document.new(buffer)
	  last_run = {}
	  
	  #extract run id
	  doc.elements.each('plusService/runList/run[last()]') do |ele|
		last_run[:nikeplus_run_id] = ele.attribute("id").to_s
	  end
	  
	  XPATHS[:last_run].each do |item|
		doc.elements.each(item[1]) do |ele|
		  last_run[item[0].to_sym] = ele.text
		end
	  end
	  last_run
	end
	
  end
end