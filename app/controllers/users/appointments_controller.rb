module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    # GET /appointments/:id
    # def show
    #   render 'show'
    # end

    def index
      @past_appointments = current_user.appointments.where('start_datetime <= ?', Time.now).order(start_datetime: :desc)

      render 'index'
    end

    # GET /appointments/upcoming
    def upcoming
      @appointments = current_user.appointments.where('start_datetime >= ?', Time.now).order(start_datetime: :asc)

      render 'upcoming'
    end

    # POST /appointments
    def create
      if (@appointment = current_user.appointments.create!(appointment_params))
        redirect_to appointments_path
      else
        redirect_to appointments_path,
                    error: " Appointment could not be created: #{@appointment.errors}"
      end
    end

    # GET /appointments/new
    def new
      @appointment = Appointment.new

      render 'new'
    end

    private

    def appointment_params
      params.require(:appointment).permit(:where, :who_with, :what, :start_datetime)
    end
  end
end
