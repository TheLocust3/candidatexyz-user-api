Rails.application.routes.draw do
  devise_for :users, skip: [ :sessions, :registrations, :passwords ]

  devise_scope :user do
    post '/users/sign-in'  => 'users/sessions#create', as: :new_user_session
    delete '/users/sign-out' => 'users/sessions#destroy', as: :destroy_user_session

    post '/users' => 'users/registrations#create'
    patch '/users' => 'users/registrations#update'

    post '/users/password' => 'users/passwords#create'
    patch '/users/password' => 'users/passwords#update', as: :user_password
  end

  get '/users/current-user' => 'users#index', defaults: { format: :json }
end
