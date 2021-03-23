module TeamMembers
  # app/controllers/team_members/team_members_controller.rb
  class TeamMembersController < AdminApplicationController
    before_action :team_member, only: %i[show approve_team_member toggle_admin]
    before_action :unapproved_team_members, :approved_team_members, only: :index

    # GET /team_members
    def index
      render 'index'
    end

    # GET /team_members/:id
    def show
      render 'show'
    end

    # PUT /team_members/:id/approve
    def approve_team_member
      if @team_member.update(approved: true)
        redirect_to team_members_path, success: "#{@team_member.first_name} has been approved"
      else
        redirect_to team_members_path, error: "#{@team_member.first_name} could not be approved"
      end
    end

    # PUT /team_members/:id/admin
    def toggle_admin
      if @team_member.update(admin: !@team_member.admin?)
        redirect_to team_members_path, notice: admin_alert
      else
        redirect_to team_members_path, error: "#{@team_member.first_name} admin status could not be changed"
      end
    end

    private

    def admin_alert
      @team_member.admin? ? "#{@team_member.first_name} is now an admin" : "#{@team_member.first_name} is no longer an admin"
    end

    def approved_team_members
      @approved_team_members = TeamMember.approved.order(:created_at)
    end

    def team_member
      @team_member = TeamMember.find(params[:id])
    end

    def unapproved_team_members
      @unapproved_team_members = TeamMember.unapproved.order(created_at: :desc)
    end
  end
end
