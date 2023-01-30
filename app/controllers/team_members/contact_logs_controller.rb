module TeamMembers
  # app/controllers/team_members/contact_logs_controller.rb
  class ContactLogsController < TeamMembersApplicationController
    before_action :contact_log, only: %i[edit update destroy toggle_attended]
    before_action :set_breadcrumbs
    include Pagination
    before_action :validate_dates, only: :create

    # GET /contact_logs/upcoming
    def recent
      @contact_logs = current_team_member.contact_logs.recent.order(start: :asc)
      render 'recent'
    end

    # POST /contact_logs
    def create
      @contact_log = ContactLog.new(
        user: contact_log_params[:user],
        contact_type: contact_log_params[:contact_type],
        notes: contact_log_params[:notes],
        start: contact_log_params[:start],
        end: contact_log_params[:end],
        team_member: current_team_member
      )

      if @contact_log.save
        session.delete(:contact_log_params)
        redirect_to upcoming_contact_logs_path, flash: { success: 'Contact log created' }
      else
        add_breadcrumb('New Contact log', nil, 'fas fa-plus circle')
        render 'new'
      end
    end

    # GET /contact_logs/new
    def new
      add_breadcrumb('New Contact log', nil, 'fas fa-plus-circle')
      @contact_log = ContactLog.new(session[:contact_log_params])

      render 'new'
    end

    # GET /contact_logs/:id/edit
    def edit
      add_breadcrumb('Edit Contact Log', nil, 'fas fa-edit')
      render 'edit'
    end

    # PUT /contact_logs/:id
    def update
      if @contact_log.update!(contact_log_params)
        redirect_to upcoming_contact_logs_path, flash: { success: 'Contact log updated' }
      else
        redirect_to edit_contact_log_path(@contact_log),
                    flash: { error: 'Contact log could not be updated. Please try again.' }
      end
    end

    # DELETE /contact_logs/:id
    def destroy
      if @contact_log.destroy!
        redirect_to upcoming_contact_logs_path, flash: { success: 'Contact log deleted' }
      else
        redirect_to upcoming_contact_logs_path(@contact_log),
                    flash: { error: 'Contact log could not be deleted. Please try again.' }
      end
    end

    protected

    def resources
      current_team_member.contact_logs.past.order(start: :desc)
    end

    def resources_per_page
      6
    end

    def search
      current_team_member.contact_logs.where(contact_log_search, wildcard_query).order(start: :desc)
    end

    private

    def contact_log
      @contact_log = current_team_member.contact_logs.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to contact_logs_path, flash: { error: 'No such contact_log could be found' }
    end

    def contact_log_search
      'lower(who_with) similar to lower(:query) or lower(what) similar to lower(:query)'
    end

    def past_contact_log_query
      query = wildcard_query
      query[:start] = 1.month.ago
      query
    end

    def contact_log_params
      params.require(:contact_log).permit(:user, :notes, :contact_type, :start, :end)
    end

    def failure
      redirect_to contact_logs_path, flash: { error: "#{@contact_log.id} attended status could not be changed" }
    end

    def validate_dates
      return if contact_log_params[:start] <= contact_log_params[:end]

      session[:contact_log_params] = contact_log_params

      redirect_back(fallback_location: new_contact_log_path, flash: { error: 'End date cannot be before start date' })
    end

    def subheading_stats
      @count_in_last_week = @resources.last_week.size
      @count_in_last_month = @resources.last_month.size
    end

    def set_breadcrumbs
      path = action_name == 'recent' ? nil : recent_contact_logs_path
      add_breadcrumb('My Contact logs', path, 'fas fa-clipboard-list')
      add_breadcrumb('Past Contact logs') unless action_name != 'index'
    end
  end
end
