module TeamMembers
  # app/controllers/team_members/view_logs_controller.rb
  class ViewLogsController < PaginationController
    before_action :require_admin
    before_action :team_member, only: :index

    protected

    def team_member
      raise 'Subclass has not overridden team_member function'
    end

    private

    def require_admin
      return if current_team_member.admin?

      redirect_to authenticated_team_member_root_path, error: 'You are not an admin'
    end
  end
end
