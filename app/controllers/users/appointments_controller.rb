module Users
  # app/controllers/users/appointments_controller.rb
  class AppointmentsController < UsersApplicationController
    before_action :appointment, only: %i[edit update destroy toggle_attended]
    include Pagination

    # GET /appointments/upcoming
    def upcoming
      @appointments = current_user.appointments.where('start >= ?', Time.now).order(start: :asc)

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

    # GET /appointments/:id/edit
    def edit
      render 'edit'
    end

    # PUT /appointments/:id
    def update
      if @appointment.update!(appointment_params)
        redirect_to upcoming_appointments_path, flash: { success: 'Appointment updated' }
      else
        redirect_to edit_appointment_path(@appointment),
                    flash: { error: 'Appointment could not be updated. Please try again.' }
      end
    end

    # DELETE /appointments/:id
    def destroy
      if @appointment.destroy!
        redirect_to upcoming_appointments_path, flash: { success: 'Appointment Deleted' }
      else
        redirect_to upcoming_appointments_path(@appointment),
                    flash: { error: 'Appointment could not be deleted. Please try again.' }
      end
    end

    # PUT /appointment/:id
    def toggle_attended
      @appointment.update(attended: !@appointment.attended?) ? success(@appointment.attended?, 'attended') : failure('not attended')
    end

    protected

    def resources
      current_user.appointments.where('start <= ?', Time.now).order(start: :desc)
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
      redirect_to appointments_path, flash: { error: 'No such appointment could be found' }
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

    def fail(type)
      redirect_to appointments_path, flash: { error: "#{@appointment.id} #{type} status could not be changed" }
    end

    def success(status, type)
      redirect_to appointments_path,
                  flash: { success: "Appointment is #{status ? 'now' : 'no longer'} #{type}" }
    end
  end
end
