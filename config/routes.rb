Rails.application.routes.draw do

  get 'users/destroy'
  # pages_controller
  get '/' => 'pages#home'

  # posts_controller
  get 'posts/index/:tag_name' => "posts#index"
  get 'posts/index' => "posts#index"
  get 'posts/new' => "posts#new"
  get 'posts/:post_id' => "posts#edit"
  post 'posts/create' => "posts#create"
  post 'posts/:post_id/update' => "posts#update"
  post 'posts/:post_id/destroy' => "posts#destroy"

  # sessions_controller
  get 'auth/:provider/callback' => 'sessions#login'
  get 'sessions/logout' => 'sessions#logout'

  # users_controller
  post 'users/:user_id' => 'users#destroy'
end
