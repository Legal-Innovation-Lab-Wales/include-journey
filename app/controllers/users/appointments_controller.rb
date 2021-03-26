module Users

  class AppointmentsController < UsersApplicationController

    # GET /appointments/:id
    def show
      render 'show'
    end

    def index
      render *'users/appointments/appointments'
    end
  end
end
