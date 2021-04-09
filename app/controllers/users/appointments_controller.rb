module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    before_action :appointments, :past_appointments, only: :index

    # GET /appointments/:id
    # def show
    #   render 'show'
    # end

    def index
      @appointment = Appointment.new

      render 'index'
    end

    # POST /appointments
    def create
      if @appointment = current_user.appointments.create!(appointment_params)
        redirect_to appointments_path
      else
        redirect_to appointments_path,
                    error: " Appointment could not be created: #{@appointment.errors}"
      end
    end

    # GET /appointments/new
    def new
      render 'new'
    end

    private

    def appointments
      @appointments = current_user.appointments.order(start_datetime: :desc)
    end

    def past_appointments
      @past_appointments = current_user.appointments.where('start_datetime <= ?', Date.today)
    end

    def appointment_params
      params.require(:appointment).permit(:where, :who_with, :what, :start_datetime)
    end
  end
end
