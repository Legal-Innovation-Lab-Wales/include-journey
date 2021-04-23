module TeamMembers
  # app/controllers/team_members/appointments_controller.rb
  class AppointmentsController < TeamMembersApplicationController
    before_action :user
    before_action :appointment, only: %i[edit update destroy]
    include Pagination

    def index; end

    def appointments
      @appointments = @user.appointments
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:appointments).find(params[:team_member_id])
    end

    def user
      return unless params[:user_id].present?

      @user = User.includes(:appointments).find(params[:user_id])
    end

    protected

    def resources
      appointments
    end

    def resources_per_page
      6
    end

    def search
      @user.appointments.where(appointment_search, wildcard_query).order(start: :desc)
    end

    private

    def appointment_search
      'lower(who_with) similar to lower(:query) or lower(what) similar to lower(:query)'
    end

    def past_appointment_query
      query = wildcard_query
      query[:start] = Time.now
      query
    end
  end
end