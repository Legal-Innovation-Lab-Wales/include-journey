module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    before_action :user, only: :show
    before_action :users, :active_users, :pinned_users, only: :index

    # GET /users
    def index
      render 'index'
    end

    # GET /users/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: "#{@user.first_name} #{@user.last_name} clicked!")
    end

    private

    def active_users
      @active_users = @users.where(last_sign_in_at: (Time.zone.now - 30.days)..Time.zone.now)
    end

    def pinned_users
      @pinned_users = @users.where(id: [1..6])
    end

    def user
      @user = User.find(params[:id])
    end

    def users
      @users = User.includes(:wba_selves, :crisis_events).all.order(created_at: :desc)
    end
  end
end
