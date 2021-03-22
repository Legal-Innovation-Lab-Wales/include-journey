module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    before_action :user, only: %i[show pin unpin]
    before_action :verify_pin, only: :pin
    before_action :verify_unpin, only: :unpin
    before_action :pinned_users, :users, :active_users, only: :index

    # GET /users
    def index
      render 'index'
    end

    # GET /users/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: "#{@user.first_name} #{@user.last_name} clicked!")
    end

    # PUT /users/:id/pin
    def pin
      maximum = current_team_member.user_pins.maximum(:order)

      if current_team_member.user_pins.create!({ user: @user, order: maximum.present? ? maximum.next : 1 })
        redirect_back(fallback_location: authenticated_team_member_root_path,
                      alert: "#{@user.first_name} #{@user.last_name} has been pinned")
      else
        redirect_back(fallback_location: authenticated_team_member_root_path,
                      alert: "#{@user.first_name} #{@user.last_name} could not be pinned")
      end
    end

    # PUT /users/:id/unpin
    def unpin
      if current_team_member.user_pins.find_by(user_id: @user.id).destroy!
        redirect_back(fallback_location: authenticated_team_member_root_path,
                      alert: "#{@user.first_name} #{@user.last_name} has been unpinned")
      else
        redirect_back(fallback_location: authenticated_team_member_root_path,
                      alert: "#{@user.first_name} #{@user.last_name} could not be unpinned")
      end
    end

    private

    def active_users
      @active_users = @users.where(last_sign_in_at: (Time.zone.now - 30.days)..Time.zone.now)
    end

    def pinned_users
      @pinned_users = current_team_member.pinned_users.order(:order)
    end

    def user
      @user = User.find(params[:id])
    end

    def users
      @users = User.includes(:wba_selves, :crisis_events).where.not(id: @pinned_users).order(created_at: :desc)
    end

    def verify_pin
      return unless current_team_member.user_pins.find_by(user_id: @user.id).present?

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: "#{@user.first_name} #{@user.last_name} is already pinned")
    end

    def verify_unpin
      return if current_team_member.user_pins.find_by(user_id: @user.id).present?

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: "#{@user.first_name} #{@user.last_name} is not currently pinned")
    end
  end
end
