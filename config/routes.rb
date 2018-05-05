Rails.application.routes.draw do
  devise_for :authors, :controllers => { registrations: 'registrations' }
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/author/:author_name', to: 'posts#author_posts'
  root to: "posts#index"

end
