module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    before_action :user, only: :show
    before_action :users, only: :index

    # GET /users
    def index
      render 'index'
    end

    # GET /users/:id
    def show
      redirect_to users_path, alert: "#{@user.first_name} #{@user.last_name} clicked!"
    end

    private

    def user
      @user = User.find(params[:id])
    end

    def users
      @users = User.all.order(:id)
    end
  end
end
