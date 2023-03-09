Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :vocabulary_words, except: [:update]
      end
      resources :words, only: [:index, :show, :create]
    end
  end
end
