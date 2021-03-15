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
  end

  authenticated :team_member do
    root 'team_members/dashboard#main', as: :authenticated_team_member_root

    put '/team_members/:team_member_id/approve', to: 'team_members/team_members#approve_team_member', as: :approve_team_member
    put '/team_members/:team_member_id/admin', to: 'team_members/team_members#toggle_admin', as: :toggle_admin


    get '/team_members/users/:user_id', to: 'team_members/users#show', as: :user
    post '/team_members/users/:user_id/note', to: 'notes#create', as: :add_user_note

  end

  unauthenticated do
    root 'pages#main'
  end
end
