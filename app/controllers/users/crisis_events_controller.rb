module Users
  # app/controllers/users/crisis_events_controller.rb
  class CrisisEventsController < UsersApplicationController
    before_action :crisis_event_params, only: %i[create update]
    before_action :crisis_event, only: :update
    after_action :sms, :email, only: %i[create update]

    # POST /crisis_events
    def create
      @crisis_event = current_user.crisis_events.create!(crisis_event_params)

      redirect_to authenticated_user_root_path,
                  alert: @crisis_event ? crisis_event_alert : 'SOS request could not be created'
    end

    # PUT /crisis_events/:id
    def update
      redirect_to authenticated_user_root_path,
                  alert: @crisis_event.update(crisis_event_params) ? update_alert : 'SOS request could not be updated'
    end

    protected

    def sms
      puts '=========================================================================================================='
      puts "CrisisEvent Type: #{@crisis_event.crisis_type.category}"
      puts "CrisisEvent Additional Info: #{@crisis_event.additional_info}"
      puts "User: #{current_user.full_name} 0#{current_user.mobile_number}"
      puts '=========================================================================================================='
    end

    def email
      @crisis_type = @crisis_event.crisis_type.category
      TeamMember.admins.each do |admin|
        CrisisEventMailer.new_crisis_email(current_user, admin, @crisis_event, @crisis_type).deliver_now
      end
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.find(params[:id])
    end

    def update_alert
      "Additional information updated for SOS created at #{@crisis_event.created}"
    end

    def crisis_event_alert
      'Thank you for reaching out, an Include UK team member will be in touch shortly'
    end

    def crisis_event_params
      params.require(:crisis_event).permit(:crisis_type_id, :additional_info)
    end
  end
end
