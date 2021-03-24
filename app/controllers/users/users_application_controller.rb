module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!, :permissions_required
    before_action :active_crisis_events, :crisis_event, :crisis_types, unless: -> { devise_controller? }

    def terms
      render 'pages/terms'
    end
    
    def home
      render 'pages/main'
    end

    private

    def active_crisis_events
      @active_crisis_events = current_user.active_crisis_events
    end

    def crisis_event
      @crisis_event = CrisisEvent.new
    end

    def crisis_types
      @crisis_types = CrisisType.all
    end

    def permissions_required
      return unless current_user.permissions_required?

      redirect_to new_journal_entry_permission_path(current_user.journal_entries.last),
                  alert: 'Please specify which team members can view this journal entry'
    end
  end
end
