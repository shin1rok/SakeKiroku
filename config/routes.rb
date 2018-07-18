Rails.application.routes.draw do
  get 'post/index' => "post#index"
  get 'post/new' => "post#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
