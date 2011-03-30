Bloomflower::Application.routes.draw do
  devise_for :users
  devise_scope :user do
     get '/login' => 'devise/sessions#new'
     get '/logout' => 'devise/sessions#destroy'
  end

  resources :votes

  resources :users

  root :to => "home#index"
  get "home/index"
end
