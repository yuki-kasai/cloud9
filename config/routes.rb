Rails.application.routes.draw do
  #   get 'posts/new'

  #   get 'users/top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'top', to: 'users#top', as: :top
  root 'users#top'

  # 通常の指定
  #   get 'posts/new', to:'posts#new', as: :new_post

  get 'users/show', to: 'users#show', as: :profile

  get '/profile/edit', to: 'users#edit', as: :profile_edit

  get '/follower_list/(:id)', to: 'users#follower_list', as: :follower_list

  get '/follow_list/(:id)', to: 'users#follow_list', as: :follow_list

  get '/sign_up', to: 'users#sign_up', as: :sign_up

  post '/sign_up', to: 'users#sign_up_process'

  get '/sign_in', to: 'users#sign_in', as: :sign_in

  post '/sign_in', to: 'users#sign_in_process'

  get '/sign_out', to: 'users#sign_out', as: :sign_out

  post '/profile/edit', to: 'users#update'

  # resourcesメソッドを使った指定
  resources :posts
  # 　resources :posts do
  #     resources :articles, :comments
  #   end
end
