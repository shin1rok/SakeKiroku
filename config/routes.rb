Rails.application.routes.draw do

  # pages_controller
  get '/' => 'pages#home'

  # posts_controller
  get 'posts/index' => "posts#index"
  get 'posts/new' => "posts#new"
  get 'posts/:post_id' => "posts#edit"
  post 'posts/create' => "posts#create"
  post 'posts/:post_id/update' => "posts#update"
  post 'posts/:post_id/destroy' => "posts#destroy"

  # sessions_controller
  get 'auth/:provider/callback' => 'sessions#login'
  get 'sessions/logout' => 'sessions#logout'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
