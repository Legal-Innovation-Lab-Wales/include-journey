module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    before_action :set_breadcrumbs
    before_action :pinned_users, :sort, :direction, :set_filters, only: :index
    before_action :check_admin, only: %i[suspend destroy]
    include Pagination

    before_action :user, except: %i[index new create]
    before_action :goal_permissions, except: %i[index new create]
    before_action :user_pin, except: %i[show index wba_history new create]
    before_action :wallich_protected, only: %i[new create]

    # GET /users/:id
    def show
      add_breadcrumb(user.full_name)
      log_view
      user_location
      wellbeing_assessment
      occupational_therapist_assessment if ENV['ORGANISATION_NAME'] == 'wallich-journey'
      @note = Note.new
      @user_notes = @user.notes.includes(:team_member, :replaced_by).order('dated DESC')
      @diary_entries = current_team_member.diary_entries.where(user: @user).includes(:diary_entry_view_logs)
      @unread_diary_entries = current_team_member.unread_diary_entries(@user)
      @appointments = @user.future_appointments.first(5) + @user.past_appointments.last(5)
      @user_tags = @user.user_tags.order({ 'created_at': :desc })
      @tags = Tag.where.not(id: @user_tags.map { |user_tag| user_tag.tag.id })
      @new_user_tag = UserTag.new(team_member: current_team_member, user: @user, created_at: DateTime.now)
      @contact_logs = ContactLog.where('user_id': @user.id)
      @summary_panel = @user.summary_panel
      @uploads = @user.uploads
      @new_folder = Folder.new
      has_goal_permissions
      @has_folders = current_team_member.folders.where(parent_folder: nil).length > 0

      render 'show'
    end

    # PUT /users/:id/pin
    def pin
      verify_pin
      maximum = current_team_member.user_pins.maximum(:order)
      @user_pin = current_team_member.user_pins.create!({ user: @user, order: maximum.present? ? maximum.next : 1 })

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin ? message('has been pinned') : message('could not be pinned'))
    end

    # DELETE /users/:id/pin
    def destroy
      name = @user.full_name
      @user.destroy!
      redirect_to users_path, flash: { success: "#{name} was successfully deleted." }
    end

    # PUT /users/:id/unpin
    def unpin
      verify_unpin
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

    # GET /users/:user_id/edit
    def edit
      add_breadcrumb(user.full_name, user_path(user))
      add_breadcrumb("Edit Details", nil, 'fas fa-edit')
      render 'edit'
    end

    # PUT /users/:user_id
    def update
      if user_params[:summary_panel].present?
        @user.update(summary_panel: user_params[:summary_panel])
      else
        @user.update(user_params)
      end

      redirect_to user_path(@user), flash: { success: "#{@user.full_name} was successfully updated." }
    end

    def suspend
      user = User.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
      user.suspended_at = user.suspended ? nil : DateTime.now
      user.suspended = !user.suspended
      user.save!

      redirect_to user_path(@user), flash: { success: "#{@user.full_name} was successfully #{user.suspended ? "suspended" : "reinstated"}." }
    end

    def new
      add_breadcrumb("Add User")
      @user = User.new
    end

    def create
      characters = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
      password = Array.new(6) { characters.sample }.join

      @user = User.create(
        email: user_params[:email],
        first_name: user_params[:first_name],
        last_name: user_params[:last_name],
        mobile_number: user_params[:mobile_number],
        date_of_birth: user_params[:date_of_birth],
        religion: user_params[:religion],
        disabilities: user_params[:disabilities],
        address: user_params[:address],
        pronouns: user_params[:pronouns],
        terms: true
        )
      @user.password = password
      if !@user.validate
        add_breadcrumb("Add User")
        return render 'new', status: :unprocessable_entity
      end 
      @user.approved = true
      @user.save!
      @user.assign_team_member(current_team_member.id)
      flash[:success] = 'User successfully created' 
      redirect_to users_path
    end

    protected
    def goal_permissions
      @user.goal_permissions.where(team_member_id: current_team_member.id)
    end

    def has_goal_permissions
      if goal_permissions.length < 1
        return false
      end

      permission = goal_permissions.first
      @goals = user.goals.where(archived: false)
      @has_short_term_permissions = permission.short_term
      @has_long_term_permissions = permission.long_term

      @has_user_goals_permission = @has_long_term_permissions || @has_short_term_permissions
      return @has_user_goals_permission
    end

    def resources
      case @sort
      when 'average'
        @users = team_member_users.approved.last_wellbeing.where.not(id: @pinned_users).order("#{@sort}": @direction)
      when 'first_name'
        # switch direction for alphabet sort
        @direction_flipped = @direction == 'desc' ? 'asc' : 'desc'
        @users = team_member_users.approved.includes(:wellbeing_assessments, :user_tags)
                     .where.not(id: @pinned_users)
                     .order({ "#{@sort}": @direction_flipped, "last_name": @direction_flipped })
      else
        @users = team_member_users.approved.includes(:wellbeing_assessments, :user_tags)
                     .where.not(id: @pinned_users)
                     .order({ "#{@sort}": @direction })
      end
      @users = users_params[:tag].present? ? @users.joins(:user_tags).where('user_tags.tag_id': users_params[:tag]) : @users
      assigned = users_params[:assigned]
      if assigned.present? && assigned == 'true'
        @users.joins(:assignments).where('assignments.team_member': current_team_member)
      else
        @users
      end
    end

    def resources_per_page
      6
    end

    def set_filters
      @tag_list = Tag.all
    end

    def search
      resources.where(user_search, wildcard_query)
    end

    def sort
      @sort = users_params[:sort] ? users_params[:sort] : 'created_at'
    end

    def direction
      @direction = %w[asc desc].include?(users_params[:direction]) ? users_params[:direction] : 'asc'
    end

    private

    def team_member_users
      if current_team_member.admin?
        User.all
      else
        current_team_member.users
      end
    end

    def log_view
      view_log = current_team_member.user_profile_view_logs.find_or_create_by!(user: @user)
      view_log.increment_view_count
      view_log.save!
    rescue ActiveRecord::RecordInvalid
      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end

    def user
      @user = team_member_users.includes(:notes).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'User not found' })
    end

    def user_location
      return @location = { 'city' => 'unknown' } if invalid_ip

      @location = Timeout.timeout(5) { JSON.parse(Net::HTTP.get_response(URI("http://ip-api.com/json/#{@user.current_sign_in_ip}" )).body) } rescue { 'city' => 'unknown' }
    end

    def invalid_ip
      return true if @user.current_sign_in_ip.blank?

      ['127.0.0.1', '::1'].include?(@user.current_sign_in_ip)
    end

    def wellbeing_assessment
      @wellbeing_assessment = @user.last_wellbeing_assessment
    rescue ActiveRecord::RecordNotFound
      session notice: 'No wellbeing assessment could be found'
    end

    def occupational_therapist_assessment
      @occupational_therapist_assessment = @user.last_occupational_therapist_assessment
    rescue ActiveRecord::RecordNotFound
      session notice: 'No wellbeing assessment could be found'
    end

    def message(message)
      "#{@user.full_name} #{message}"
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

    def subheading_stats
      @total_users = User.approved.count
      @active_last_week = @resources.active_last_week.size
      @active_last_month = @resources.active_last_month.size
    end

    def check_admin
      return if current_team_member.admin?

      redirect_to(authenticated_team_member_root_path) and return
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :pronouns, :date_of_birth, :email, :mobile_number, :sex,
                                   :gender_identity, :religion, :ethnic_group, :disabilities,
                                   :nomis_id, :pnc_no, :delius_no, :enrolled_at, :intervened_at,
                                   :release_establishment, :probation_area, :local_authority, :pilot_completed_at,
                                   :pilot_withdrawn_at, :withdrawn, :withdrawn_reason, :index_offence, :summary_panel,
                                   :referral_date, :mam_date, :accommodation_type_id, :housing_provider_id,
                                   :brief_physical_description, :priority_id, :local_authority_id,
                                   :support_ended_date, :next_review_date, :support_ending_reason_id,
                                   :referred_from_id, :support_started_date, :address)
    end

    def users_params
      params.permit(:sort, :direction, :tag, :query, :page, :assigned)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : users_path
      add_breadcrumb('Users', path, 'fas fa-user')
    end

    def wallich_protected
      if ENV['ORGANISATION_NAME'] != 'wallich-journey'
        redirect_back(fallback_location: authenticated_team_member_root_path)
      end
    end
  end
end