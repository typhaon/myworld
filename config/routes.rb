Rails.application.routes.draw do
  root to: "worlds#index"

  resources :worlds
end
