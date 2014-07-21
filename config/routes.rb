Rails.application.routes.draw do
  root to: "worlds#new"

  resources :worlds
end
