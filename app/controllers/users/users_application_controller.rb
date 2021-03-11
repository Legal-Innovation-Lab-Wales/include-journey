module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!
    before_action :crisis_event, :crisis_types, unless: -> { devise_controller? }

    private

    def crisis_event
      @crisis_event = CrisisEvent.new
    end

    def crisis_types
      @crisis_types = CrisisType.all
    end
  end
end
