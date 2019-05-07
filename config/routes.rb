Rails.application.routes.draw do
  #   get 'posts/new'

  #   get 'users/top'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'top', to: 'users#top', as: :top
  root 'users#top'

  # 通常の指定
  #   get 'posts/new', to:'posts#new', as: :new_post

  get '/profile/edit', to: 'users#edit', as: :profile_edit

  post '/profile/edit', to: 'users#update'

  get '/profile/(:id)', to: 'users#show', as: :profile

  get '/follower_list/(:id)', to: 'users#follower_list', as: :follower_list

  get '/follow_list/(:id)', to: 'users#follow_list', as: :follow_list

  get '/sign_up', to: 'users#sign_up', as: :sign_up

  post '/sign_up', to: 'users#sign_up_process'

  get '/sign_in', to: 'users#sign_in', as: :sign_in

  post '/sign_in', to: 'users#sign_in_process'

  get '/sign_out', to: 'users#sign_out', as: :sign_out

  post '/profile/edit', to: 'users#update'
  
  # いいね機能
  # get '/posts/(:id)/like', to: 'posts#like'

  # resourcesメソッドを使った指定
  resources :posts do
    member do
      # いいね
      get 'like', to: 'posts#like', as: :like
      # コメント投稿
      post 'comment', to: 'posts#comment', as: :comment
    end
  end
end
