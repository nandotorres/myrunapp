class UsersController < ApplicationController
  before_filter :authorized?
  
  def index
    
  end

  def show
    @user = User.find(params[:id].to_i) if owner?
  end

  def update
    
    @user = User.find(params[:id].to_i) if owner?
    params[:user][:nikeplus_id]     = User.extract_user_id_from_url(params[:user][:nikeplus_url].to_s) if params[:user][:nikeplus_url].present?
    user_data                       = User.parse_xml_user_data(params[:user][:nikeplus_id]) if params[:user][:nikeplus_id] && can_request?
    params[:user][:avatar]          = user_data[:avatar] unless user_data.nil?
    params[:user][:total_distance]  = user_data[:totalDistance] unless user_data.nil?
    params[:user][:last_manual_sync]= Time.now

    if @user.update_attributes(params[:user])
      redirect_to(user_path(@user), :notice => t(:user_successfully_updated))
    else
      redirect_to(user_path(@user), :notice => t(:user_unsuccessfully_updated))
    end
    
  end

  def request_nikeplus_user_data
    respond_to do |format|
      uid       = params[:uid].to_i
      user_data = User.parse_xml_user_data(uid)
      format.json {render :json => user_data}
    end
  end

  def manual_sync
    respond_to do |format|
      uid              = session[:user_id]
      @user            = User.find(uid)
      last_manual_sync = @user.last_manual_sync
      now              = Time.now.utc
      #avoid to flood request for sync waint at least five minutes between requests
      response = []
      if can_request?
        run_data = @user.parse_xml_last_run
        if run_data.empty? || Run.find_by_nikeplus_run_id(run_data[:nikeplus_run_id])
          response.push({:error => true, :error_type => I18n.t(:no_new_run)})
          @user.last_manual_sync = Time.now
          @user.save
        else
          run = create_new_run_by_run_data(run_data)
          @user.last_run_day   = Time.iso8601(run_data[:syncTime])
          @user.last_manual_sync = Time.now
          @user.save
          @user.post_to_facebook(run.id)
          response.push({ :error => false, :run => {:nikeplus_run_id => run.nikeplus_run_id,
                          :date => run.regionalized_date,
                          :duration => run.regionalized_duration,
                          :speed => run.regionalized_speed,
                          :calories => run.calories,
                          :distance => "#{run.distance}#{run.user_distance_unit}"}
                         })
        end
      else
        response.push({:error => true, :error_type => I18n.t(:wait_until) + (last_manual_sync.in_time_zone(@user.timezone) + 10.minutes).strftime("%H:%M")})
      end
      format.json {render :json => response}
    end
  end

  private

  def create_new_run_by_run_data(run_data)
    run = Run.new    
    run.nikeplus_run_id = run_data[:nikeplus_run_id]    
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
    run.start_time      = Time.iso8601(run_data[:startTime])
    run.sync_time       = Time.iso8601(run_data[:syncTime])
    run.user_id         = @user.id
    run.save
    run
  end

  def owner?
    if !(params[:id].to_i == current_user.id)
      session[:user_id] = nil
      redirect_to root_path, :notice => t(:invalid_access)
    else
    true
    end
  end
  
  def can_request?
    @user.last_manual_sync.nil? || (Time.now.utc - @user.last_manual_sync) > 10.minutes.to_i
  end  

end
