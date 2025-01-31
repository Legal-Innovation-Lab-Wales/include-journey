module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    before_action :appointment, only: %i[edit update destroy toggle_attended]
    before_action :set_breadcrumbs
    include Pagination
    before_action :validate_dates, only: %i[create update]

    # GET /appointments/upcoming
    def upcoming
      @appointments = current_user.appointments.future.order(start: :asc)
      @count_in_next_week = @appointments.next_week.size
      render 'upcoming'
    end

    # GET /appointments/new
    def new
      add_breadcrumb('New Appointment', nil, 'fas fa-plus-circle')
      @appointment = Appointment.new(session[:appointment_params])

      render 'new'
    end

    # GET /appointments/:id/edit
    def edit
      add_breadcrumb('Edit Appointment', nil, 'fas fa-edit')
      render 'edit'
    end

    # POST /appointments
    def create
      @appointment = Appointment.new(
        where: appointment_params[:where],
        who_with: appointment_params[:who_with],
        what: appointment_params[:what],
        start: appointment_params[:start],
        end: appointment_params[:end],
        user: current_user,
      )

      if @appointment.save
        session.delete(:appointment_params)
        redirect_to(
          upcoming_appointments_path,
          flash: {success: 'Appointment created'},
        )
      else
        add_breadcrumb('New Appointment', nil, 'fas fa-plus circle')
        render 'new'
      end
    end

    # PUT /appointments/:id
    def update
      if @appointment.update(appointment_params)
        redirect_to(
          upcoming_appointments_path,
          flash: {success: 'Appointment updated'},
        )
      else
        add_breadcrumb('Edit Appointment', nil, 'fas fa-edit')
        render 'edit'
      end
    end

    # DELETE /appointments/:id
    def destroy
      if @appointment.destroy!
        redirect_to(
          upcoming_appointments_path,
          flash: {success: 'Appointment deleted'},
        )
      else
        redirect_to(
          upcoming_appointments_path(@appointment),
          flash: {error: 'Appointment could not be deleted. Please try again.'},
        )
      end
    end

    # PUT /appointment/:id
    def toggle_attended
      if @appointment.update(attended: !@appointment.attended?)
        success(@appointment.attended?)
      else
        failure
      end
    end

    protected

    def resources
      current_user.appointments.past.order(start: :desc)
    end

    def resources_per_page
      6
    end

    def search
      current_user.appointments.where(appointment_search, wildcard_query).order(start: :desc)
    end

    private

    def appointment
      @appointment = current_user.appointments.where('team_member_id is null').find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to(
        appointments_path,
        flash: {error: 'No such appointment could be found'},
      )
    end

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

    def failure
      redirect_to(
        appointments_path,
        flash: {error: "#{@appointment.id} attended status could not be changed"},
      )
    end

    def success(status)
      message = "#{status ? 'Congrats! ' : ''}Appointment has been marked as #{status ? 'now' : 'no longer'} attended"
      redirect_back(
        fallback_location: appointments_path,
        flash: {success: message},
      )
    end

    def validate_dates
      start_date = DateTime.parse(appointment_params[:start])
      end_date = DateTime.parse(appointment_params[:end])

      return if (end_date.after? start_date) || (start_date === end_date)

      session[:appointment_params] = appointment_params

      redirect_back(
        fallback_location: new_appointment_path,
        flash: {error: 'End date cannot be before start date'},
      )
    end

    def subheading_stats
      @count_in_last_week = @resources.last_week.size
      @count_in_last_month = @resources.last_month.size
    end

    def set_breadcrumbs
      path = action_name == 'upcoming' ? nil : upcoming_appointments_path
      add_breadcrumb('My Appointments', path, 'fas fa-calendar-alt')
      add_breadcrumb('Past Appointments') unless action_name != 'index'
    end
  end
end
