Rails.application.routes.draw do
  root to: 'root#index'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords:  'passwords'
  }

  get 'staff_positions' => 'users#get_positions'
  get 'staff' => 'users#index'
  get 'staff/:id' => 'users#show'
  post 'staff' => 'users#create'
  post 'staff/create_invite' => 'users#create_invite'
  patch 'staff/:id' => 'users#update'
  delete 'staff/:id' => 'users#destroy'

  resources :campaigns, defaults: { format: :json }
  get 'campaigns/name/:name' => 'campaigns#show_by_name', defaults: { format: :json }
end
