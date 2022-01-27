module TeamMembers
  # app/controllers/team_members/team_members_controller.rb
  class TeamMembersController < AdminApplicationController
    before_action :team_member, except: :index

    # GET /team_members
    def index
      @unapproved_team_members = TeamMember.unapproved.order(created_at: :desc)
      @approved_team_members = TeamMember.approved.order(created_at: :desc)

      render 'index'
    end

    # GET /team_members/:id
    def show
      render 'show'
    end

    # PUT /team_members/:id/approve
    def approve
      @team_member.update(approved: true) ? success(true, 'approved') : failure('approval')
    end

    # PUT /team_members/:id/reject
    def reject
      return if @team_member.approved

      team_member_name = @team_member.full_name
      if @team_member.destroy
        redirect_to team_members_path, flash: { success: "#{team_member_name} has been rejected" }
      else
        redirect_to team_members_path, flash: { error: "#{team_member_name} could not be rejected" }
      end
    end

    # PUT /team_members/:id/admin
    def toggle_admin
      team_member_is_admin = @team_member.admin?
      @team_member.update(admin: !team_member_is_admin) ? success(team_member_is_admin, 'an admin') : failure('admin')
    end

    # PUT /team_members/:id/suspend
    def toggle_suspend
      team_member_is_suspended = @team_member.suspended?
      @team_member.update!(suspended: !team_member_is_suspended)

      success(team_member_is_suspended, 'suspended')
    end

    private

    def fail(type)
      redirect_to team_members_path, flash: { error: "#{@team_member.first_name} #{type} status could not be changed" }
    end

    def success(status, type)
      redirect_to team_members_path,
                  flash: { success: "#{@team_member.first_name} is #{status ? 'now' : 'no longer'} #{type}" }
    end

    def team_member
      @team_member = TeamMember.find(params[:id])
    end
  end
end
