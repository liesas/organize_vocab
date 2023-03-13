Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorization, :application, :authorized_applications
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :users
      resources :vocabulary_words, except: [:update]
      resources :words, only: [:index, :show, :create]
    end
  end
end
