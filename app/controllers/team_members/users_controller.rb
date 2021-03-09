module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    before_action :set_user

    def show
      redirect_to authenticated_team_member_root_path, alert: "#{@user.first_name} #{@user.last_name} clicked!"
    end

    private

    def set_user
      @user = User.find(params[:user_id].to_i)
    end
  end
end
