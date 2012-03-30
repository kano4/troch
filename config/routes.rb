require 'resque/server'
Troch::Application.routes.draw do
  mount Resque::Server, at: "/resque"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root           :to => 'pages#index'
  get '/edit',   :to => 'pages#edit'
  put '/update', :to => 'pages#update'
  get '/alert',  :to => 'pages#alert'
  get '/log',    :to => 'pages#log'

  devise_for :users
  resources :sites
  resources :groups

  match '/settings/',             :to => 'settings#index'
  match '/settings/watch_on_off', :to => 'settings#watch_on_off'
  match '/settings/info',         :to => 'settings#info'
end
