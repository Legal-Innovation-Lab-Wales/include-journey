module TeamMembers
  # app/controllers/team_members/view_logs_controller.rb
  class ViewLogsController < PaginationController
    before_action :require_admin
    before_action :page, :limit, :offset, :team_member, :resources, :count, :last_page, :limit_resources, only: :index
    before_action :redirect, only: :index, unless: -> { @resources.present? }

    protected

    def team_member
      raise 'Subclass has not overridden view_log_path function'
    end

    private

    def require_admin
      return if current_team_member.admin?

      redirect_to authenticated_team_member_root_path, error: 'You are not an admin'
    end
  end
end
