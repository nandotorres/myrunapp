class SessionsController < ApplicationController
 
	def create
	  auth = request.env["omniauth.auth"]
	  user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
	  user.increment(:login_count)
	  user.last_login = Time.now
	  user.save
	  session[:user_id] = user.id
	  redirect_to user_path(user.id), :notice => t(:sign_in_successfully)
	end

	def destroy
	  session[:user_id] = nil
	  redirect_to root_url, :notice => t(:sign_out_successfully)
	end
	
end
