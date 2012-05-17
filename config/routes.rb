Myrunapp::Application.routes.draw do

  resources :users do  
    resources :runs
  end
  
  root :to => 'home#index'
  match "/users_ajax/request_nikeplus_user_data" => "users#request_nikeplus_user_data"
  match "/users_ajax/manual_sync" => "users#manual_sync"
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout 
  
end
