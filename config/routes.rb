# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: %i[index show destroy]
  resources :selects, only: %i[index]
  post 'send_message', to: 'selects#send_message'
end
