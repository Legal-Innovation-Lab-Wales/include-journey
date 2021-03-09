module TeamMembers
  # app/controllers/team_members/team_members_controller.rb
  class TeamMembersController < TeamMembersApplicationController
    before_action :require_admin, :set_team_member

    # GET /team_members/:team_member_id
    def show
      render template: 'team_members/team_members/show'
    end

    # PUT /team_members/:team_member_id/approve
    def approve_team_member
      respond_to do |format|
        if @team_member.update(approved: true)
          format.html { redirect_to authenticated_team_member_root_path, alert: "#{@team_member.first_name} has been approved" }
        else
          format.html { redirect_to authenticated_team_member_root_path, warning: "#{@team_member.first_name} could not be approved" }
        end
      end
    end

    # PUT /team_members/:team_member_id/admin
    def toggle_admin
      respond_to do |format|
        if @team_member.update(admin: !@team_member.admin?)
          format.html { redirect_to authenticated_team_member_root_path, alert: admin_alert }
        else
          format.html { redirect_to authenticated_team_member_root_path, warning: "#{@team_member.first_name} admin status could not be changed" }
        end
      end
    end

    private

    def admin_alert
      @team_member.admin? ? "#{@team_member.first_name} is now an admin" : "#{@team_member.first_name} is no longer an admin"
    end

    def set_team_member
      @team_member = TeamMember.find(params[:team_member_id].to_i)
    end
  end
end