Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'home#index'
  get 'units/index'
  get 'squads/map'
  get 'setups/new_game'
  get 'setups/finaliza_turno'

  resources :messages do
    member do
     get :deleta
    end
  end

  resources :planets

  resources :results

  resources :setups

  resources :squads

  resources :fleets do
    member do
      patch :move
      patch :embark
      patch :disembark
      patch :build
      patch :arm
      patch :upgrade
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
