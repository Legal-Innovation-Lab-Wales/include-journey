module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!
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
  end
end
