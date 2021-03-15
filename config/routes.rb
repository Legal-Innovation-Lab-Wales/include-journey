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
    scope module: 'users' do
      root 'dashboard#show', as: :authenticated_user_root

      resources :wba_selves, only: %i[show new create] do
        resources :wba_self_permissions, only: %i[new create]
      end

      resources :journal_entries, only: %i[new create index] do
        get 'dashboard', to: 'journal_entries_dashboard#show', on: :collection, as: :dashboard
        resources :journal_entry_permissions, only: %i[new create]
      end

      resources :crisis_events, only: :create do
        put '/:crisis_event_id', to: 'crisis_events#update', on: :collection, as: :update_crisis_event
      end
    end
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
