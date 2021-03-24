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
      get 'home', to: 'users_application#home'

      resources :wba_selves, only: %i[show new create]

      resources :journal_entries, only: %i[index new create] do
        get 'dashboard', action: :dashboard, on: :collection

        resources :journal_entry_permissions, only: %i[new create], as: :permissions
      end

      resources :crisis_events, only: %i[create update]
    end
  end

  authenticated :team_member do
    scope module: 'team_members' do
      root 'dashboard#show', as: :authenticated_team_member_root
      get 'home', to: 'team_members_application#home'

      resources :team_members, only: %i[index show] do
        put 'approve', action: 'approve_team_member', on: :member, as: :approve
        put 'admin', action: 'toggle_admin', on: :member, as: :toggle_admin

        resources :journal_entry_view_logs, only: :index, on: :member
      end

      resources :users, only: %i[index show] do
        put 'pin', action: 'pin', on: :member, as: :pin
        put 'increment', action: 'increment', on: :member, as: :increment
        put 'decrement', action: 'decrement', on: :member, as: :decrement
        put 'unpin', action: 'unpin', on: :member, as: :unpin
      end

      resources :crisis_events, only: %i[index show] do
        get 'active', action: 'active', on: :collection
        put 'close', action: 'close', on: :member, as: :close
        post 'note', action: 'add_note', on: :member, as: :notes
      end

      resources :wba_team_members, only: :show
      resources :journal_entries, only: %i[show index]
    end
  end

  unauthenticated do
    root 'pages#main'
  end

end
