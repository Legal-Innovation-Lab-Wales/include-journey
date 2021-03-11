module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!
    before_action :active_crisis_events, :crisis_event, :crisis_types, unless: -> { devise_controller? }

    private

    def active_crisis_events
      @active_crisis_events = current_user.crisis_events.where('created_at > ? and closed is ?', 1.hours.ago, false).includes(:crisis_type)
    end

    def crisis_event
      @crisis_event = CrisisEvent.new
    end

    def crisis_types
      # @crisis_types = CrisisType.all
      half_count = (CrisisType.all.count / 2.0).ceil
      @crisis_types_first_half = CrisisType.all.limit(half_count)
      @crisis_types_last_half = CrisisType.all.offset(half_count)
    end
  end
end
