# frozen_string_literal: true

module Users
  # app/controllers/users/crisis_events_controller.rb
  class CrisisEventsController < UsersApplicationController
    before_action :crisis_event_params, only: :new
    after_action :sms, :email, only: :new

    # POST /crisis_events/new
    def new
      if (@crisis_event = current_user.crisis_events.create!(crisis_event_params))
        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: crisis_event_alert }
        end
      else
        render @crisis_event.errors, status: :unprocessable_entity
      end
    end

    protected

    def sms
      puts '=========================================================================================================='
      puts "CrisisEvent Type: #{@crisis_event.crisis_type.category}"
      puts "CrisisEvent Additional Info: #{@crisis_event.additional_info}"
      puts "User: #{current_user.first_name} #{current_user.last_name} 0#{current_user.mobile_number}"
      puts '=========================================================================================================='
    end

    def email
      puts '=========================================================================================================='
      puts "CrisisEvent Type: #{@crisis_event.crisis_type.category}"
      puts "CrisisEvent Additional Info: #{@crisis_event.additional_info}"
      puts "User: #{current_user.first_name} #{current_user.last_name} #{current_user.email}"
      puts '=========================================================================================================='
    end

    private

    def crisis_event_alert
      'Thank you for reaching out, an Include UK team member will be in touch shortly'
    end

    def crisis_event_params
      params.require(:crisis_event).permit(:crisis_type_id, :additional_info)
    end
  end
end