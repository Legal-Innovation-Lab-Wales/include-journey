module TeamMembers

  class UsersController < TeamMembersApplicationController
    # need to add before_action :is_team_member? or similar
    before_action :set_team_member, :set_unapproved_team_members, :set_approved_team_members,
                  :set_users, :set_user, :set_user_location, only: :show

    private

    def show
      respond_to do |format|
        format.html
      end
    end

    def set_user
      @user = User.find(params[:id])
    end

    def set_user_location
      @user_location = @user.last_sign_in_ip
    end

    def set_team_member
      @current_team_member = TeamMember.find(4)
    end

    def set_unapproved_team_members
      @unapproved_team_members = TeamMember.find(1, 2)
    end

    def set_approved_team_members
      @approved_team_members = TeamMember.find(3, 4)
    end

    def set_users
      @users = User.find(5, 6, 7)
    end
  end
end
