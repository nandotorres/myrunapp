Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env == 'production'
    provider :facebook, "269203533174795", "64ac4527d7e0cbbe31dc77227d338450", :scope => 'email, offline_access, user_birthday, publish_actions, read_friendlists', :client_options => {:ssl => {:ca_file => "#{Rails.root}/cacert.pem"}}
  elsif Rails.env == 'stage'
    provider :facebook, "269203533174795", "64ac4527d7e0cbbe31dc77227d338450", :scope => 'email, offline_access, user_birthday, publish_actions, read_friendlists', :client_options => {:ssl => {:ca_file => "#{Rails.root}/cacert.pem"}}
  else
    provider :facebook, "273397849389307", "510c890606fc0e0db1d1c37f45f12f5e", :scope => 'email, offline_access, user_birthday, publish_actions, read_friendlists', :client_options => {:ssl => {:ca_file => "#{Rails.root}/cacert.pem"}}
  end
end