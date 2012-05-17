class RunsController < ApplicationController
  before_filter :authorized?
  def index
    @user = User.find(params[:user_id])
    @runs = @user.runs.order("start_time DESC")
  end
end
