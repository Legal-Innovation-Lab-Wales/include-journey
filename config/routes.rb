Rails.application.routes.draw do
  resources :notes
  devise_for :users, path: 'users',
                     controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    sessions: 'users/sessions',
                                    passwords: 'users/passwords',
                                    unlocks: 'users/unlocks' }
  devise_for :team_members, path: 'team_members',
                            controllers: { registrations: 'team_members/registrations',
                                           confirmations: 'team_members/confirmations',
                                           sessions: 'team_members/sessions',
                                           passwords: 'team_members/passwords',
                                           unlocks: 'team_members/unlocks' }

  authenticated :user do
    root 'users/dashboard#main', as: :authenticated_user_root

    post '/wba_selves/create', to: 'users/wba_selves#create', as: :wba_selves
    post '/wba_selves/:wba_self_id/wba_self_permissions/create', to: 'users/wba_self_permissions#create', as: :wba_self_permissions

    post '/crisis_events/create', to: 'users/crisis_events#create', as: :crisis_events
    put '/crisis_events/:crisis_event_id', to: 'users/crisis_events#update', as: :update_crisis_event

    post '/journal_entries/create', to: 'users/journal_entries#create', as: :journal_entries
    post '/journal_entries/:journal_entry_id/journal_entry_permissions/create', to: 'users/journal_entry_permissions#create', as: :journal_entry_permissions
  end

  authenticated :team_member do
    root 'team_members/dashboard#main', as: :authenticated_team_member_root

    get '/team_members/:team_member_id', to: 'team_members/team_members#show', as: :team_member
    put '/team_members/:team_member_id/approve', to: 'team_members/team_members#approve_team_member', as: :approve_team_member
    put '/team_members/:team_member_id/admin', to: 'team_members/team_members#toggle_admin', as: :toggle_admin
    get '/team_members/:team_member_id/wba/:wba_team_member_id', to: 'team_members/wba_team_members#show', as: :wba_team_member

    get '/users/:user_id', to: 'team_members/users#show', as: :user
  end

  unauthenticated do
    root 'pages#main'
  end
end
