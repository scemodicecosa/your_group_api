Rails.application.routes.draw do
    devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json} do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: false) do

      post '/groups/:group_id/add_user/:id', to: 'groups#add_user'
      delete '/groups/:group_id/remove_user/:id', to: 'groups#remove_user'
      get '/groups/:id/participants', to: 'groups#participants'
      put '/groups/:id/roles/:user_id', to: 'groups#update_role'
      get '/groups/:id/accept', to: 'groups#accept'

      post '/groups/:group_id/polls', to: 'polls#create'
      get 'polls/:poll_id/vote/:vote', to: 'polls#vote'

      post '/groups/:id/actions', to: 'actions#create'
      post '/groups/:id/actions/assign', to: 'actions#assign'

      resources :polls, only: [:show]
      resources :users, only: [:show, :update, :create]
      resources :sessions, only: [:create]
      resources :groups, only: [:show, :create, :update]
      delete :sessions, to: "sessions#destroy"
    end
  end
end
