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

  get 'guide', to: 'guides#index'
  get 'guide_diary', to: 'guides#diary'
  get 'guide_appointments', to: 'guides#appointments'
  get 'guide_myNeeds', to: 'guides#myNeeds'
  get 'guide_contacts', to: 'guides#contacts'
  get 'guide_support', to: 'guides#support'
  get 'guide_goals', to: 'guides#goals'
  post 'report_issue', to: 'report_issue#send_report'

  authenticated :user do
    scope module: 'users' do
      root 'dashboard#show', as: :authenticated_user_root
      get 'home', to: 'users_application#home'
      get 'terms', to: 'users_application#terms'
      get 'privacy_notice', to: 'users_application#privacy_notice'
      get 'cookie_policy', to: 'users_application#cookie_policy'
      get 'coming_soon', to: 'coming_soon#coming_soon', as: :coming_soon
      put 'cancel_deletion', to: 'users_application#cancel_deletion', as: :cancel_deletion
      get 'journey', to: 'journey#index', as: :journey

      resources :goal_permissions, as: :goal_permissions do
        delete 'destroy', action: :destroy
      end

      resources :wellbeing_assessments, only: %i[show new create]
      resources :diary_entries, only: %i[index new create] do
        resources :diary_entry_permissions, only: %i[new create], as: :permissions do
          get 'edit', action: :edit, on: :collection
        end
      end
      resources :appointments do
        get 'upcoming', action: :upcoming, on: :collection
        put 'attended', action: 'toggle_attended', on: :member, as: :toggle_attended
      end
      resources :contacts
      resources :goals, only: %i[index create show destroy] do
        put 'achieve', action: :achieve, on: :member
        put 'archive', action: :archive, on: :member
      end
      resources :goals_archive, only: :index
      resources :wellbeing_services, only: :index
      resources :surveys, only: %i[index show update]
      resources :messages, only: [:index], as: :archive_messages
      get 'main_messages', to: 'messages#main'
      resources :uploads, only: %i[index new show create update destroy] do
        get 'download_file', on: :member
      end
      resources :notifications, only: %i[index]
      match '/500', to: 'errors#internal_server_error', via: :all
    end
    get '/*path', to: redirect('')
  end

  # rubocop:disable Metrics/BlockLength
  authenticated :team_member do
    scope module: 'team_members' do
      resource :two_factor_settings, except: %i[index show]

      root 'dashboard#show', as: :authenticated_team_member_root

      get 'home', to: 'team_members_application#home'
      get 'terms', to: 'team_members_application#terms'
      get 'privacy_notice', to: 'team_members_application#privacy_notice'
      get 'cookie_policy', to: 'team_members_application#cookie_policy'
      resources :team_members, only: %i[index show] do
        put 'approve', action: 'approve', on: :member, as: :approve
        put 'reject', action: 'reject', on: :member, as: :reject
        put 'admin', action: 'toggle_admin', on: :member, as: :toggle_admin
        put 'suspend', action: 'toggle_suspend', on: :member, as: :toggle_suspend

        resources :user_profile_view_logs, only: :index, on: :member
        resources :assign_users, only: %i[index create approve], on: :member, as: :users do
          get 'approve', to: 'assign_users#approve', as: 'approve'
        end
        resources :diary_entry_view_logs, only: :index, on: :member
        resources :wellbeing_assessments, only: :index, on: :member do
          get 'export', on: :collection
        end
        resources :occupational_therapist_assessments, only: :index
        resources :contact_logs, on: :member do
          get 'recent', action: :recent, on: :collection
        end
        resources :upload_activity_logs, only: :index, on: :member
      end

      resources :approvals do
        collection do
          post :bulk_action
        end
      end
      resources :users, only: %i[index show update destroy] do
        get 'create', action: 'new', on: :collection, as: :new
        post 'create', action: 'create', on: :collection, as: :create
        put 'pin', action: 'pin', on: :member, as: :pin
        put 'increment', action: 'increment', on: :member, as: :increment
        put 'decrement', action: 'decrement', on: :member, as: :decrement
        put 'unpin', action: 'unpin', on: :member, as: :unpin
        patch 'suspend', action: 'suspend', on: :member, as: :suspend
        get 'goals', action: 'goals', on: :member, as: :goals
        get 'approve', action: 'approve', on: :member, as: :approve

        resources :notes, only: %i[create update show]
        get 'wba_history', action: 'wba_history', on: :member
        resources :wellbeing_assessments, only: %i[new create index], on: :member do
          get 'export', on: :collection
        end
        resources :appointments, only: %i[index new create edit update], on: :member do
          put 'attended', action: 'toggle_attended', on: :member, as: :toggle_attended
        end
        resources :contact_logs, on: :member do
          get 'recent', action: :recent, on: :collection
        end
        resources :tags, only: %i[create destroy], on: :member, controller: :user_tags
        get 'edit', action: 'edit', on: :member, as: :edit
        resources :uploads, only: %i[index new show create update destroy] do
          member do
            get 'download_file'
            get :approve
          end
        end
        resources :folders, only: %i[index create update destroy], as: :folders do
          get 'children', to: 'child_folders#index', as: 'children'
          post 'children', to: 'child_folders#create', as: 'create_child'
          delete 'children', to: 'child_folders#destroy', as: 'delete_child'
          delete '', to: 'folders#destroy', as: 'delete'
          put '', to: 'folders#update', as: 'update'
        end
        resources :occupational_therapist_assessments, only: %i[index new create]
      end

      resources :analytics, only: %i[index] do
        get 'export', on: :collection
      end
      get 'analytics/update_search'
      resources :wellbeing_assessments, only: %i[show index] do
        get 'export', on: :collection
      end
      resources :occupational_therapist_assessments, only: %i[index show]
      resources :contact_logs do
        get 'recent', action: :recent, on: :collection
      end
      resources :diary_entries, only: %i[show index]
      resources :wellbeing_services
      resources :wellbeing_metrics, only: %i[index update]
      resources :wellbeing_score_values, only: %i[index update]
      resources :tags, only: %i[show index create] do
        resources :user_tags, only: :index, on: :member, as: :tagged_users
      end
      resources :affirmations, except: :show
      resources :affirmations_archive, only: :index
      resources :surveys, param: :survey_id do
        member do
          put '/activate', action: 'activate'
          put '/reorder', action: 'reorder'
          resources :survey_sections, only: %i[create update destroy], param: :section_id, as: :survey_section do
            member do
              put '/reorder', action: 'reorder'
              resources :survey_questions, only: %i[create update destroy], param: :question_id, as: :survey_question
              resources :survey_comment_sections, only: %i[create update destroy], param: :comment_section_id, as: :survey_comment_section do
                member do
                  resources :survey_comments, only: :index, as: :survey_comments
                end
              end
            end
          end
          resources :survey_responses, only: %i[index show], param: :response_id, as: :survey_response
        end
      end
      resources :notifications
      put 'edit_notification_frequency', to: 'notifications#update_notification_frequency', as: :edit_notification_frequency
      match '/500', to: 'errors#internal_server_error', via: :all
    end
    get '/*path', to: redirect('')
  end
  # rubocop:enable Metrics/BlockLength

  unauthenticated do
    root to: redirect('/users/sign_in')
    get 'about', to: 'pages#about'
    get 'terms', to: 'pages#terms'
    get 'privacy_notice', to: 'pages#privacy_notice'
    get 'cookie_policy', to: 'pages#cookie_policy'
    get '/*path', to: redirect('/users/sign_in')
  end
end
