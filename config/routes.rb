Rails.application.routes.draw do
  devise_for :authors, :controllers => { registrations: 'registrations' }
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/author/:author_name', to: 'posts#author_posts'
  
  get '/tag/:tag_name', to: 'posts#tag_posts'
  post '/tag/new', to: 'tags#new', as: :new_tag
  put '/tags/:id', to: 'tags#update'
  delete '/tags/:id', to: 'tags#delete'

  post '/save_collapse_state/', to: 'posts#save_collapse_state', as: :save_collapse_state
  post '/sort_posts/', to: 'posts#sort_posts', as: :sort_posts

  root to: "posts#index"

end
