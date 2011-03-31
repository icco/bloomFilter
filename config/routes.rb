Bloomflower::Application.routes.draw do
   devise_for :users do
      get '/login' => 'devise/sessions#new'
      get '/logout' => 'devise/sessions#destroy'
   end

   resources :items
   resources :users

   match "/vote/:id/up" => "votes#up", :as => 'vote_up'
   match "/vote/:id/flag" => "votes#flag", :as => 'vote_flag'

   root :to => "home#index"
end
