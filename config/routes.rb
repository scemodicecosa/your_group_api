Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json}do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do
      namespace :groups do
        post :add_user, to: 'add_user'
        post :remove_user
      end
      resources :users, only: [:show, :update]
      resources :sessions, only: [:create, :destroy]
      resources :groups, only: [:show,:create]

    end
  end
end
