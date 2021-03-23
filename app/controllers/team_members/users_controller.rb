module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < PaginationController
    before_action :user, except: %i[index search]
    before_action :maximum, :user_pin, except: %i[show index search]
    before_action :verify_pin, only: :pin
    before_action :verify_unpin, only: :unpin
    before_action :query, :pinned_users, :active_users, only: :index

    before_action :search, :redirect, only: :index, if: -> { @query.present? }

    # GET /users/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path, notice: message('clicked!'))
    end

    # PUT /users/:id/pin
    def pin
      @user_pin = current_team_member.user_pins.create!({ user: @user, order: @maximum.present? ? @maximum.next : 1 })

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: @user_pin ? message('has been pinned') : message('could not be pinned'))
    end

    # PUT /users/:id/unpin
    def unpin
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: @user_pin.destroy! ? message('has been unpinned') : message('could not be unpinned'))
    end

    # PUT /users/:id/increment
    def increment
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: @user_pin.increment ? message('pin successfully moved') : message('pin could not be moved'))
    end

    # PUT /users/:id/decrement
    def decrement
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: @user_pin.decrement ? message('pin successfully moved') : message('pin could not be moved'))
    end

    protected

    def limit
      @limit = 6
    end

    def resources
      @resources = User.includes(:wba_selves, :crisis_events).where.not(id: current_team_member.pinned_users)
                       .order(created_at: :desc)
    end

    private

    def active_users
      @active_users = User.where(last_sign_in_at: (Time.zone.now - 30.days)..Time.zone.now).count
    end

    def maximum
      @maximum = current_team_member.user_pins.maximum(:order)
    end

    def message(message)
      "#{@user.full_name} #{message}"
    end

    def query_params
      params.permit(:query, :page)
    end

    def pinned_users
      @pinned_users = current_team_member.pinned_users.order(:order)
    end

    def query
      @query = query_params[:query]
    end

    def search
      @resources = User.where('lower(first_name) like lower(?) or lower(last_name) like lower(?)',
                              "%#{@query}%", "%#{@query}%")
    end

    def user
      @user = User.find(params[:id])
    end

    def user_pin
      @user_pin = current_team_member.user_pins.find_by(user_id: @user.id)
    end

    def verify_pin
      return unless @user_pin.present?

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: message('is already pinned'))
    end

    def verify_unpin
      return if @user_pin.present?

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: message('is not currently pinned'))
    end
  end
end
