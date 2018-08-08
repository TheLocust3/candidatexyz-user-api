Rails.application.routes.draw do
  root to: 'root#index'

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords:  'passwords'
  }

  get 'staff_positions' => 'users#get_positions', defaults: { format: :json }
  get 'staff' => 'users#index', defaults: { format: :json }
  get 'staff/get_invite' => 'users#get_invite', defaults: { format: :json }
  get 'staff/:id' => 'users#show', defaults: { format: :json }
  post 'staff' => 'users#create', defaults: { format: :json }
  post 'staff/create_invite' => 'users#create_invite', defaults: { format: :json }
  patch 'staff/:id/campaign_id' => 'users#update_campaign_id', defaults: { format: :json }
  patch 'staff/:id' => 'users#update', defaults: { format: :json }
  delete 'staff/:id' => 'users#destroy', defaults: { format: :json }

  get 'users/users_with_committee_positions' => 'users#get_users_with_committee_positions', defaults: { format: :json }
  resources :campaigns, defaults: { format: :json }
  get 'campaigns/name/:name' => 'campaigns#show_by_name', defaults: { format: :json }
end
