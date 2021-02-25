Rails.application.routes.draw do
  resources :notes
  devise_for :users, path: 'users',
                     controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    sessions: 'users/sessions',
                                    passwords: 'users/passwords',
                                    unlocks: 'users/unlocks_controller' }
  devise_for :team_members, path: 'team_members',
                            controllers: { registrations: 'team_members/registrations',
                                           confirmations: 'team_members/confirmations',
                                           sessions: 'team_members/sessions',
                                           passwords: 'team_members/passwords',
                                           unlocks: 'team_members/unlocks_controller' }

  unauthenticated do
    root 'pages#main'
  end

  authenticated :user do
    root 'users/dashboard#main', as: :authenticated_user_root
  end

  authenticated :team_member do
    root 'team_members/dashboard#main', as: :authenticated_team_member_root
  end
end
