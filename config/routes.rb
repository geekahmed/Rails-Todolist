Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :todo
  resources :user, only: [:create]
  post "/login", to: "user#login"
  get "/auto_login", to: "user#auto_login"
  get "/logout", to: "user#logout"
  get "/export", to: "todo#export"
  get "/search", to: "todo#search"
end
