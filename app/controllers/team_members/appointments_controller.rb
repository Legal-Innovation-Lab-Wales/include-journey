module TeamMembers
  # app/controllers/team_members/appointments_controller.rb
  class AppointmentsController < TeamMembersApplicationController
    before_action :user
    before_action :appointment, only: %i[edit update destroy]
    include Pagination

    # GET /users/:user_id/appointments/new
    def new
      @appointment = Appointment.new

      render 'new'
    end

    # POST /users/:user_id/appointments
    def create
      if (@appointment = @user.appointments.create!(appointment_params.merge!(team_member: current_team_member)))
        redirect_to user_path(@user), flash: { success: 'Appointment created' }
      else
        redirect_to user_path(@user),
                    flash: { error: "Appointment could not be created: #{@appointment.errors}" }
      end
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
      @user.appointments
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

    def appointment_params
      params.require(:appointment).permit(:where, :who_with, :what, :start, :end)
    end

    def subheading_stats
      @count_in_last_week = @resources.where('appointments.start >= ?', 1.week.ago).size
      @count_in_last_month = @resources.where('appointments.start >= ?', 1.month.ago).size
      @count_in_next_weeks = @resources.where('appointments.start <= ?', 2.week.ago).size
      return unless @user

      @count_by_team_member = @resources.count { |appointment| appointment.team_member_id.present? }
      @count_by_user = @resources.count { |appointment| appointment.team_member_id.nil? }
    end
  end
end
