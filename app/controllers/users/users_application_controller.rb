module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!, :crisis_event, :crisis_types

    private

    def crisis_event
      @crisis_event = CrisisEvent.new
    end

    def crisis_types
      @crisis_types = CrisisType.all
    end
  end
end
