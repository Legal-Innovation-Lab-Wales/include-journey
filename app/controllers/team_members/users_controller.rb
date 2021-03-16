module TeamMembers

  class UsersController < TeamMembersApplicationController
    # need to add before_action :is_team_member? or similar
    before_action :set_unapproved_team_members, :set_approved_team_members,
                  :set_users, :set_user, :set_user_location, :note, :user_notes, only: :show


    def show
      render 'show'
    end

    private

    def note
      @note = Note.new
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def user_notes
      @user_notes = @user.notes.order(created_at: :desc)
    end

    def set_user_location
      @user_location = @user.last_sign_in_ip
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
