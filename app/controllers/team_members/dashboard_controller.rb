module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < TeamMemberController
    before_action :require_admin, only: [:set_team_member, :approve_team_member, :toggle_admin]
    before_action :set_team_member, only: [:approve_team_member, :toggle_admin]

    def main
      render template: 'team_members/dashboard/main'
    end

    # PUT /team_members/:team_member_id/approve
    def approve_team_member
      respond_to do |format|
        debugger
        format.html { redirect_to authenticated_team_member_root_path,
                                  alert: @team_member.update(approved: true) ?
                                           "#{@team_member.first_name} has been approved" :
                                           "#{@team_member.first_name} could not be approved" }
      end
    end

    # PUT /team_members/:team_member_id/admin
    def toggle_admin
      respond_to do |format|
        if @team_member.update(admin: !@team_member.admin?)
          format.html { redirect_to authenticated_team_member_root_path,
                                    alert: @team_member.admin? ?
                                             "#{@team_member.first_name} is now an admin" :
                                             "#{@team_member.first_name} is no longer an admin" }
        else
          format.html { redirect_to authenticated_team_member_root_path,
                                    warning: "#{@team_member.first_name} admin status could not be changed" }
        end
      end
    end

    private

    def set_team_member
      @team_member = TeamMember.find(params[:team_member_id].to_i)
    end
  end
end