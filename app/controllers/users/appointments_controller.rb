module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    before_action :appointments, only: :index

    # GET /appointments/:id
    def show
      render 'show'
    end

    def index
      render 'index'
    end

    # POST /appointments
    def create
      if (@appointment = current_user.appointments.create())
        redirect_to new_journal_entry_permission_path(@appointment), success: 'New Appointment entry added'
      else
        redirect_to authenticated_user_root_path, error: "Appointment entry could not be created: #{@appointment.errors}"
      end
    end

    private

    def appointment
      @appointment = Appointment.new
    end

    def appointments
      @appointments = current_user.appointments
    end
  end
end
