Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get 'planets/index'
  get 'units/index'

  resources :squads

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
