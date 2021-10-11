Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :todo
  resources :user, only: [:create]
  post "/login", to: "user#login"
  get "/auto_login", to: "user#auto_login"
end
