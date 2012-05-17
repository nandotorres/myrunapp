class User < ActiveRecord::Base
  has_many :runs, :dependent => :destroy
  include MyRunAppAPI
  def full_name
    "#{name} #{last_name}"
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      #parameters list https://github.com/mkdynamic/omniauth-facebook
      user.provider 	= auth["provider"]
      user.uid 			= auth["uid"]
      user.name 		= auth["info"]["first_name"]
      user.last_name 	= auth["info"]["last_name"]
      user.email 		= auth["info"]["email"]
      user.image_url 	= auth["info"]["image"]
      user.timezone		= auth["extra"]["raw_info"]["timezone"]
      user.locale 		= auth["extra"]["raw_info"]["locale"]
      user.token      = auth["credentials"]["token"]
    end
  end

  def self.parse_xml_user_data(uid)
    nikeplus = MyRunAppAPI::Nikeplus.new
    nikeplus.parse_xml_user_data(uid)
  end

  def self.extract_user_id_from_url(url)
    nikeplus    = MyRunAppAPI::Nikeplus.new
    nikeplus.extract_user_id_from_url(url)
  end

  def parse_xml_last_run
    nikeplus = MyRunAppAPI::Nikeplus.new
    run = nikeplus.parse_xml_last_run(nikeplus_id)
  end

  def post_to_facebook(run_id)
    @run = runs.find(run_id)
    I18n.locale = locale
    message     = build_message
    description = build_description
    me = FbGraph::User.me(token)
    me.feed!(
      :message => message,
      :link => 'http://www.myrunapp.com/',
      :name => 'MyRun App (beta)',
      :description => description
    )
  end

  def get_level_color
    return "yellow" if total_distance.between?(0, 49)
    return "orange" if total_distance.between?(50, 249)
    return "green" if total_distance.between?(250, 999)
    return "blue" if total_distance.between?(1000, 2500)
    return "purple" if total_distance.between?(2500, 4999)
    return "black" if total_distance >= 5000
  end
  
  def greeting_msg
    msg = I18n.t(:msg_firsttime) if login_count <= 1
    msg = I18n.t(:msg_welcome) if nikeplus_url.present? && nikeplus_id.present?
    msg = I18n.t(:msg_needsetup) if nikeplus_url.blank?
    msg = I18n.t(:msg_missconfigured) if nikeplus_url.present? && nikeplus_id.to_i == 0
    msg.gsub(/{name}/,name) 
  end
  
  private

  def build_message
    message = I18n.t(:fb_runpost_base_message)
    message = message.gsub("{name}", name)
    message = message.gsub("{distance}", @run.distance.round(2).to_s)
    message = message.gsub("{distance_unit}", @run.user_distance_unit)
    message = message.gsub("{equipment}", @run.user_run_equipment)
  end

  def build_description
    description = I18n.t(:fb_runpost_base_description)
    description = description.gsub("{break}", "<center></center>")
    description = description.gsub("{date}", @run.regionalized_date)
    description = description.gsub("{duration}", @run.regionalized_duration)
    description = description.gsub("{speed}", @run.regionalized_speed)
    description = description.gsub("{calories}", @run.calories.to_s)
  end

end
