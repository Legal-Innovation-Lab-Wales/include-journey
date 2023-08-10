module TeamMembers
  # app/controllers/team_members/team_members_controller.rb
  class TeamMembersController < AdminApplicationController
    before_action :team_member, except: :index
    before_action :set_breadcrumbs

    # GET /team_members
    def index
      @unapproved_team_members = TeamMember.unapproved.order(created_at: :desc)
      @approved_team_members = TeamMember.approved.order(created_at: :desc)

      render 'index'
    end

    # GET /team_members/:id
    def show
      add_breadcrumb(team_member.full_name, nil, 'fas fa-user')
      render 'show'
    end

    # PUT /team_members/:id/approve
    def approve
      @team_member.update(approved: true) ? success(true, 'approved') : failure('approval')
    end

    # PUT /team_members/:id/reject
    def reject
      return if @team_member.approved

      if @team_member.destroy
        redirect_to team_members_path, flash: { success: "#{@team_member.full_name} has been rejected" }
      else
        redirect_to team_members_path, flash: { error: "#{@team_member.full_name} could not be rejected" }
      end
    end

    # PUT /team_members/:id/admin
    def toggle_admin
      @team_member.update(admin: !@team_member.admin?) ? success(@team_member.admin?, 'an admin') : failure('admin')
    end

    # PUT /team_members/:id/suspend
    def toggle_suspend
      @team_member.update!(suspended: !@team_member.suspended?)

      success(@team_member.suspended?, 'suspended')
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
      @team_member = TeamMember.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : team_members_path
      add_breadcrumb('Team Members', path, 'fas fa-users')
    end
  end
end
