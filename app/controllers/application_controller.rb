class ApplicationController < ActionController::Base
  before_filter :redirect_if_no_starts_with_www, :set_locale
  protect_from_forgery  
  
  def set_locale
	I18n.locale = (current_user) ? i18n_locale_from_language(current_user.locale) : i18n_locale_from_language(extract_locale_from_accept_language_header)
  end
  
  def current_user
	@current_user = User.find(session[:user_id]) if session[:user_id]
  end
  
  def authorized?
	redirect_to root_url, :notice => t(:must_be_logged) and return if !is_logged?
  end
  
  private

  def is_logged?
	!current_user.nil?
  end  
  
  def i18n_locale_from_language(lang = 'en')
    langs = {}
	langs['en']    = 'en'
	langs['en-us'] = 'en'
	langs['pt_BR'] = 'pt_BR'
	langs['pt-br'] = 'pt_BR'
	langs[lang] || 'en'
  end 
  
  def extract_locale_from_accept_language_header
    lang = request.env['HTTP_ACCEPT_LANGUAGE'] ? request.env['HTTP_ACCEPT_LANGUAGE'].scan(/(^[a-z]{2})(-[a-z]{2})?/).first.join("") : 'pt_BR'
  end
  
  def redirect_if_no_starts_with_www
    head :moved_permanently, :location => "http://www.#{request.domain}" if (Rails.env == "production" && request.host == "myrunapp.com")
  end
end
