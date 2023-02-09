module TeamMembers
  # app/controllers/team_members/appointments_controller.rb
  class AppointmentsController < TeamMembersApplicationController
    before_action :user
    before_action :set_breadcrumbs
    include Pagination

    # GET /users/:user_id/appointments/new
    def new
      add_breadcrumb('New Appointment', nil, 'fas fa-plus-circle')
      @appointment = Appointment.new

      render 'new'
    end

    # POST /users/:user_id/appointments
    def create
      @appointment = @user.appointments.create(
        appointment_params.merge!(team_member: current_team_member)
      )
      if @appointment.save
        redirect_to user_path(@user), flash: { success: 'Appointment created' }
      else
        add_breadcrumb('New Appointment', nil, 'fas fa-plus circle')
        render 'new'
      end
    end

    def user
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
      @count_in_last_week = @resources.last_week.size
      @count_in_last_month = @resources.last_month.size
      @count_in_next_weeks = @resources.next_fortnight.size
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(user.full_name, user_path(user))

      add_breadcrumb('Appointments') unless action_name != 'index'
    end
  end
end
