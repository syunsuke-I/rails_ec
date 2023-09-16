# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/items', to: 'items#index'
end
  