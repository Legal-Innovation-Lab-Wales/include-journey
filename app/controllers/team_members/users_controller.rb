module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < PaginationController
    before_action :user, except: :index
    before_action :user_location, :note, :user_notes, :wellbeing_assessment, :journal_entries, :unread_entries, :active_crisis, only: :show
    before_action :maximum, :user_pin, except: %i[show index]
    before_action :verify_pin, only: :pin
    before_action :verify_unpin, only: :unpin
    before_action :pinned_users, :active_users, :user_count, only: :index

    # GET /users/:id
    def show
      render 'show'
    end

    # PUT /users/:id/pin
    def pin
      @user_pin = current_team_member.user_pins.create!({ user: @user, order: @maximum.present? ? @maximum.next : 1 })

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin ? message('has been pinned') : message('could not be pinned'))
    end

    # PUT /users/:id/unpin
    def unpin
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.destroy! ? message('has been unpinned') : message('could not be unpinned'))
    end

    # PUT /users/:id/increment
    def increment
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.increment ? message('pin successfully moved') : message('pin could not be moved'))
    end

    # PUT /users/:id/decrement
    def decrement
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.decrement ? message('pin successfully moved') : message('pin could not be moved'))
    end

    # GET /users/:user_id/wba_history
    def wba_history
      respond_to do |format|
        format.json { render json: @user.wellbeing_assessment_history.as_json, status: :ok }
      end
    end

    protected

    def resources
      @resources = if @query.present?
                     User.includes(:wellbeing_assessments, :crisis_events)
                         .where(user_search, wildcard_query)
                         .order(created_at: :desc)
                   else
                     User.includes(:wellbeing_assessments, :crisis_events)
                         .where.not(id: current_team_member.pinned_users)
                         .order(created_at: :desc)
                   end
    end

    private

    def note
      @note = Note.new
    end

    def user
      @user = User.includes(:notes).find(params[:id])
    end

    def user_count
      @user_count = User.count
    end

    def user_notes
      @user_notes = @user.notes.includes(:team_member).order(created_at: :desc)
    end

    def user_location
      return @location = { 'city' => 'unknown' } if invalid_ip

      @location = Timeout.timeout(5) { JSON.parse(Net::HTTP.get_response(URI("http://ip-api.com/json/#{@user.current_sign_in_ip}" )).body) } rescue { 'city' => 'unknown' }
    end

    def invalid_ip
      return true  if @user.current_sign_in_ip.blank?

      ['127.0.0.1', '::1'].include?(@user.current_sign_in_ip)
    end

    def wellbeing_assessment
      @wellbeing_assessment = @user.last_wellbeing_assessment
    rescue ActiveRecord::RecordNotFound
      session notice: 'No wellbeing assessment could be found'
    end

    def active_crisis
      @active_crisis = @user.crisis_events.active
    end

    def journal_entries
      @journal_entries = current_team_member.journal_entries.where(user: @user)
    end

    def unread_entries
      @unread_journal_entries = current_team_member.unread_journal_entries(@user)
    end

    def active_users
      @active_users = User.where(last_sign_in_at: (Time.zone.now - 30.days)..Time.zone.now).count
    end

    def maximum
      @maximum = current_team_member.user_pins.maximum(:order)
    end

    def message(message)
      "#{@user.full_name} #{message}"
    end

    def multiple
      @multiple = 6
    end

    def pinned_users
      @pinned_users = current_team_member.pinned_users.order(:order)
    end

    def user_pin
      @user_pin = current_team_member.user_pins.find_by(user_id: @user.id)
    end

    def user_search
      'lower(first_name) similar to lower(:query) or lower(last_name) similar to lower(:query)'
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
