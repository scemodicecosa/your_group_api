Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json}do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do
      resources :users, only: [:show]
      resources :sessions, only: [:create, :destroy]
    end
  end
end
