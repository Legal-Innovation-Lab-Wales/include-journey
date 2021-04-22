module TeamMembers
  # app/controllers/team_members/appointments_controller.rb
  class AppointmentsController < TeamMembersApplicationController
    before_action :user, except: :show
    before_action :appointment, only: %i[edit update destroy]
    include Pagination

    def index; end

    def upcoming
      render 'team_members/appointments/upcoming'
    end

    private

    def resources
      appointments
    end

    def appointment
      # TODO: Make this make sense
      @appointment = current_team_member.appointments.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to appointments_path, flash: { error: 'No such appointment could be found' }
    end

    def appointments
      @appointments = @user.appointments
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:appointments).find(params[:team_member_id])
    end

    def user
      return unless params[:user_id].present?

      @user = User.includes(:appointments).find(params[:user_id])
    end
  end
end