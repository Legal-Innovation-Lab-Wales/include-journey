module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < PaginationController
    # GET /appointments/upcoming
    def upcoming
      @appointments = current_user.appointments.where('start_datetime >= ?', Time.now).order(start_datetime: :asc)

      render 'upcoming'
    end

    # POST /appointments
    def create
      if (@appointment = current_user.appointments.create!(appointment_params))
        redirect_to upcoming_appointments_path, flash: { success: 'Appointment created' }
      else
        redirect_to upcoming_appointments_path,
                    flash: { error: "Appointment could not be created: #{@appointment.errors}" }
      end
    end

    # GET /appointments/new
    def new
      @appointment = Appointment.new

      render 'new'
    end

    protected

    def resources
      @resources =
        if @query.present?
          current_user.appointments.where("start_datetime <= :start and #{appointment_search}", past_appointment_query)
                      .order(start_datetime: :desc)
        else
          current_user.appointments.where('start_datetime <= ?', Time.now).order(start_datetime: :desc)
        end
    end

    def multiple
      @multiple = 6
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
      params.require(:appointment).permit(:where, :who_with, :what, :start_datetime)
    end
  end
end
