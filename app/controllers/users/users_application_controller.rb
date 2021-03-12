# frozen_string_literal: true

module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!, :wba_self_permissions_required, :journal_entry_permissions_required
    before_action :active_crisis_events, :crisis_event, :crisis_types, unless: -> { devise_controller? }

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

    def wba_self_permissions_required
      return unless current_user.wba_self_permissions_required?

      redirect_to new_wba_self_wba_self_permission_path(current_user.wba_selves.last),
                  alert: 'Please specify which team members can view this wellbeing assessment'
    end

    def journal_entry_permissions_required
      return unless current_user.journal_entry_permissions_required?

      redirect_to new_journal_entry_journal_entry_permission_path(current_user.journal_entries.last),
                  alert: 'Please specify which team members can view this journal entry'
    end
  end
end
