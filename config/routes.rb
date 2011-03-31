Bloomflower::Application.routes.draw do
   devise_for :users do
      get '/login' => 'devise/sessions#new'
      get '/logout' => 'devise/sessions#destroy'
   end

   resources :items
   resources :users

   match "/vote/:id/up" => "votes#up"
   match "/vote/:id/flag" => "votes#flag"

   root :to => "home#index"
end
