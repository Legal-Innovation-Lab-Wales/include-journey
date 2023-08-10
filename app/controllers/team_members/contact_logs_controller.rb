module TeamMembers
  # app/controllers/team_members/contact_logs_controller.rb
  class ContactLogsController < TeamMembersApplicationController
    before_action :contact_log, only: %i[edit update destroy]
    before_action :get_user, only: %i[index recent recent_team_member_contacts new create]
    before_action :set_breadcrumbs
    include Pagination
    before_action :validate_dates, only: %i[create update]

    # GET /contact_logs/recent
    def recent
      if @user
        @contact_logs = ContactLog.where('user_id': @user.id).recent.order(start: :desc)
      elsif @team_member
        @contact_logs = ContactLog.where('team_member_id': @team_member.id).recent.order(start: :desc)
      else
        @contact_logs = current_team_member.contact_logs.recent.order(start: :desc)
      end
      @count_in_last_week = @contact_logs.last_week.size

      render 'recent'
    end

    # POST /contact_logs
    def create
      @contact_log = ContactLog.new(
        user: @user ? @user : User.where(id: contact_log_params[:user_id]).first,
        contact_type: ContactType.where(id: contact_log_params[:contact_type_id]).first,
        contact_purpose: ContactPurpose.where(id: contact_log_params[:contact_purpose_id]).first,
        notes: contact_log_params[:notes],
        start: contact_log_params[:start],
        end: contact_log_params[:end],
        team_member: current_team_member
      )

      if @contact_log.save
        session.delete(:contact_log_params)
        redirect_to @user ? recent_user_contact_logs_path(@user) : recent_contact_logs_path, flash: { success: 'Contact log created' }
      else
        add_breadcrumb('New Contact log', nil, 'fas fa-plus circle')
        form_resources

        render 'new'
      end
    end

    # GET /contact_logs/new
    def new
      add_breadcrumb('New Contact log', nil, 'fas fa-plus-circle')
      @contact_log = ContactLog.new(session[:contact_log_params])
      form_resources

      render 'new'
    end

    # GET /contact_logs/:id/edit
    def edit
      add_breadcrumb('Edit Contact Log', nil, 'fas fa-edit')
      form_resources

      render 'edit'
    end

    # PUT /contact_logs/:id
    def update
      if @contact_log.update(contact_log_params)
        @contact_log.save
        redirect_to recent_contact_logs_path, flash: { success: 'Contact log updated' }
      else
        redirect_to edit_contact_log_path(@contact_log),
                    flash: { error: 'Contact log could not be updated. Please try again.' }
      end
    end

    # DELETE /contact_logs/:id
    def destroy
      if @contact_log.destroy!
        redirect_to recent_contact_logs_path, flash: { success: 'Contact log deleted' }
      else
        redirect_to recent_contact_logs_path(@contact_log),
                    flash: { error: 'Contact log could not be deleted. Please try again.' }
      end
    end

    protected

    def resources
      if @user
        ContactLog.where('user_id': @user.id).past.order(start: :desc)
      elsif @team_member
        ContactLog.where('team_member_id': @team_member.id).past.order(start: :desc)
      else
        current_team_member.contact_logs.past.order(start: :desc)
      end
    end

    def resources_per_page
      6
    end

    def search
      if @user
        ContactLog.where('user_id': @user.id).where(contact_log_search, wildcard_query).order(start: :desc)
      elsif @team_member
        ContactLog.where('team_member_id': @team_member.id).where(contact_log_search, wildcard_query).order(start: :desc)
      else
        current_team_member.contact_logs.where(contact_log_search, wildcard_query).order(start: :desc)
      end
    end

    private

    def form_resources
      @contact_types = ContactType.all
      @contact_purposes = ContactPurpose.all
      @users = User.approved.order(email: :asc)
    end

    def contact_log
      @contact_log = current_team_member.contact_logs.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to contact_logs_path, flash: { error: 'No such contact_log could be found' }
    end

    def contact_log_search
      'lower(notes) similar to lower(:query)'
    end

    def past_contact_log_query
      query = wildcard_query
      query[:start] = 1.month.ago
      query
    end

    def contact_log_params
      params.require(:contact_log).permit(:user_id, :notes, :contact_type_id, :contact_purpose_id, :start, :end)
    end

    def failure
      redirect_to contact_logs_path, flash: { error: "#{@contact_log.id} attended status could not be changed" }
    end

    def validate_dates
      start_date = DateTime.parse(contact_log_params[:start])
      end_date = DateTime.parse(contact_log_params[:end])

      return if (end_date.after? start_date) || (start_date === end_date)

      session[:contact_log_params] = contact_log_params

      redirect_back(fallback_location: new_contact_log_path, flash: { error: 'End date cannot be before start date' })
    end

    def set_breadcrumbs
      # if recent action, no path
      # if user exists use user recent logs
      # if none use team member recent logs
      path = action_name == 'recent' ? nil : @user ? recent_user_contact_logs_path(@user) : recent_contact_logs_path
      if @user
        add_breadcrumb('Users', users_path, 'fas fa-users')
        add_breadcrumb(@user.full_name, @user, 'fas fa-user')
        add_breadcrumb('Contact logs', path, 'fas fa-clipboard-list')
      elsif @team_member
        path = action_name == 'recent' ? nil : recent_team_member_contact_logs_path(@team_member)
        add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
        add_breadcrumb(@team_member.full_name, @team_member, 'fas fa-user')
        add_breadcrumb('Contact logs', path, 'fas fa-clipboard-list')
      else
        add_breadcrumb('My Contact logs', path, 'fas fa-clipboard-list')
      end
      add_breadcrumb('Archived Contact logs') unless action_name != 'index'
    end

    def get_user
      if params[:user_id].present?
        puts 'User ID'
        @user = User.where(id: ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id])).first
        return unless !@user.present?

        redirect_to authenticated_team_member_root_path
      elsif params[:team_member_id].present?
        puts 'Team Member ID'
        @team_member = TeamMember.where(id: ActiveRecord::Base::sanitize_sql_for_conditions(params[:team_member_id])).first
        return unless !@team_member.present?

        redirect_to authenticated_team_member_root_path
      end
    end
  end
end
