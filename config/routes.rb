Rails.application.routes.draw do
  namespace :v1 do
    namespace :v1 do
      get 'documentation/show'
      get 'documentation/create'
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documentation, only: [:show, :create, :index, :new]

  namespace :api, defaults: {format: :json}do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do

      post '/groups/:group_id/add_user/:id', to: 'groups#add_user'
      delete '/groups/:group_id/remove_user/:id', to: 'groups#remove_user'
      resources :users, only: [:show, :update, :create]
      resources :sessions, only: [:create]
      resources :groups, only: [:show,:create]
      delete :sessions, to: "sessions#destroy"
    end
  end
end
