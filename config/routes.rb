Rails.application.routes.draw do
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
      get 'terms', to: 'users_application#terms'
      get 'coming_soon', to: 'coming_soon#coming_soon', as: :coming_soon
      put 'cancel_deletion', to: 'users_application#cancel_deletion', as: :cancel_deletion

      resources :wellbeing_assessments, only: %i[show new create]
      resources :journal_entries, only: %i[index new create] do
        resources :journal_entry_permissions, only: %i[new create], as: :permissions do
          get 'edit', action: :edit, on: :collection
        end
      end
      resources :appointments do
        get 'upcoming', action: :upcoming, on: :collection
        put 'attended', action: 'toggle_attended', on: :member, as: :toggle_attended
      end
      resources :crisis_events, only: %i[create update]
      resources :contacts
      resources :goals, only: %i[index create show destroy] do
        put 'achieve', action: :achieve, on: :member
        put 'archive', action: :archive, on: :member
      end
      resources :goals_archive, only: :index
      resources :wellbeing_services, only: :index
    end
  end

  # rubocop:disable Metrics/BlockLength
  authenticated :team_member do
    scope module: 'team_members' do
      root 'dashboard#show', as: :authenticated_team_member_root
      get 'home', to: 'team_members_application#home'
      get 'terms', to: 'team_members_application#terms'

      resources :team_members, only: %i[index show] do
        put 'approve', action: 'approve', on: :member, as: :approve
        put 'reject', action: 'reject', on: :member, as: :reject
        put 'admin', action: 'toggle_admin', on: :member, as: :toggle_admin
        put 'suspend', action: 'toggle_suspend', on: :member, as: :toggle_suspend

        resources :user_profile_view_logs, only: :index, on: :member
        resources :journal_entry_view_logs, only: :index, on: :member
        resources :wellbeing_assessments, only: :index, on: :member
      end

      resources :users, only: %i[index show] do
        put 'pin', action: 'pin', on: :member, as: :pin
        put 'increment', action: 'increment', on: :member, as: :increment
        put 'decrement', action: 'decrement', on: :member, as: :decrement
        put 'unpin', action: 'unpin', on: :member, as: :unpin
        resources :notes, only: %i[create update show]
        get 'wba_history', action: 'wba_history', on: :member
        resources :wellbeing_assessments, only: %i[new create index], on: :member
        resources :appointments, only: %i[index new create edit update], on: :member
        resources :tags, only: %i[create destroy], on: :member, controller: :user_tags
      end

      resources :crisis_events, only: %i[index show] do
        get 'active', action: 'active', on: :collection
        put 'close', action: 'close', on: :member, as: :close
        resources :notes, only: %i[create show update], controller: :crisis_notes
      end

      resources :wellbeing_assessments, only: %i[show index]
      resources :journal_entries, only: %i[show index]
      resources :wellbeing_services
      resources :wellbeing_metrics, only: %i[index update]
      resources :wellbeing_scores, only: %i[index update]
      resources :tags, only: %i[show index create] do
        resources :user_tags, only: :index, on: :member, as: :tagged_users
      end
    end
  end
  # rubocop:enable Metrics/BlockLength

  unauthenticated do
    root to: redirect('/users/sign_in')
    get 'about', to: 'pages#about'
    get 'terms', to: 'pages#terms'
  end
end
