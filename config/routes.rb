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

      resources :wba_selves, only: %i[show new create]

      resources :journal_entries, only: %i[new create] do
        get 'page/:page_number', action: :index, on: :collection, as: :pages
        get 'dashboard', action: :dashboard, on: :collection

        resources :journal_entry_permissions, only: %i[new create], as: :permissions
      end

      resources :crisis_events, only: %i[create update]
    end
  end

  authenticated :team_member do
    scope module: 'team_members' do
      root 'dashboard#show', as: :authenticated_team_member_root

      resources :team_members, only: %i[index show] do
        put 'approve', action: 'approve_team_member', on: :member, as: :approve
        put 'admin', action: 'toggle_admin', on: :member, as: :toggle_admin

        get 'journal_entry_view_logs/page/:page_number', to: 'journal_entry_view_logs#index', on: :member, as: :journal_entry_view_logs
      end

      resources :users, only: %i[index show]

      resources :crisis_events, only: :show do
        get 'page/:page_number', action: :index, on: :collection, as: :pages
        get 'active', action: 'active', on: :collection
        put 'close', action: 'close', on: :member, as: :close
        post 'note', action: 'add_note', on: :member, as: :notes
      end

      resources :wba_team_members, only: :show

      resources :journal_entries, only: :show do
        get 'page/:page_number', action: :index, on: :collection
      end
    end
  end

  unauthenticated do
    root 'pages#main'
  end
end
