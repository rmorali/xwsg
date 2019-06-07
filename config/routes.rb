Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  get 'units/index'
  get 'squads/map'
  get 'setups/new_game'

  resources :setups

  resources :planets

  resources :squads

  resources :fleets do
    member do
      patch :move
      patch :embark
      patch :disembark
      patch :build
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
