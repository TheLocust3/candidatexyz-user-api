Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords:  'passwords'
  }

  get 'staff' => 'users#index'
  get 'staff/:id' => 'users#show'
  post 'staff' => 'users#create'
  post 'staff/create_invite' => 'users#create_invite'
  patch 'staff/:id' => 'users#update'
  delete 'staff/:id' => 'users#destroy'
end
