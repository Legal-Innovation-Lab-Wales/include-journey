module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    before_action :appointments, :past_appointments, only: :index

    # GET /appointments/:id
    def show
      render 'show'
    end

    # GET /appointments/new
    def new
      render 'new'
    end

    def index
      render 'index'
    end

    # POST /appointments
    def create
      if (@appointment = current_user.appointments.create!)
        redirect_to appointments_path
      else
        redirect_to appointments_path,
                    error: " Appointment could not be created: #{@appointment.errors}"
      end
    end

    private

    def appointment
      @appointment = Appointment.new
    end

    def appointments
      @appointments = current_user.appointments.order('start_datetime').where('start_datetime >= ?', Date.today)
    end

    def past_appointments
      @past_appointments = current_user.appointments.where('start_datetime <= ?', Date.today)
    end
  end
end
