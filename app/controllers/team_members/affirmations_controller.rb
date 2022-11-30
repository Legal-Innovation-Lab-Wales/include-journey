module TeamMembers
  # app/controllers/team_members/affirmations_controller.rb
  class AffirmationsController < TeamMembersApplicationController
    before_action :affirmation, except: %i[index new create]
    before_action :sort, :direction, only: :index
    before_action :update_unique_check, only: :update
    before_action :create_unique_check, only: :create
    before_action :set_breadcrumbs

    after_action :clear_session_data, only: :new

    # GET /affirmations
    def index
      @affirmations = Affirmation.includes(:team_member).upcoming.order({ "#{@sort}": @direction })

      render 'index'
    end

    # GET /affirmations/new
    def new
      add_breadcrumb('New Affirmation',nil, 'fas fa-plus-circle')
      text = session[:affirmation_text].present? ? session[:affirmation_text] : ''
      latest = Affirmation.order(scheduled_date: :desc).first
      date = latest.present? && latest.scheduled_date > Date.today ? latest.scheduled_date + 1.days : Date.today

      @affirmation = Affirmation.new(text: text, scheduled_date: date)

      render 'new'
    end

    # POST /affirmations
    def create
      @affirmation = Affirmation.create!(
        text: affirmation_params[:text],
        scheduled_date: affirmation_params[:scheduled_date],
        team_member: current_team_member
      )

      success('created')
    end

    # GET /affirmations/:id/edit
    def edit
      add_breadcrumb('Edit Affirmation', nil, 'fas fa-edit')
      render 'edit'
    end

    # PUT /affirmations/:id
    def update
      @affirmation.update(
        text: affirmation_params[:text],
        scheduled_date: affirmation_params[:scheduled_date],
        team_member: current_team_member
      )

      success('updated')
    end

    # DELETE /affirmations/:id
    def destroy
      @affirmation.destroy!

      success('removed')
    end

    def direction
      @direction = %w[asc desc].include?(affirmations_params[:direction]) ? affirmations_params[:direction] : 'asc'
    end

    def sort
      @sort = 'scheduled_date'
    end

    private

    def affirmation
      @affirmation = Affirmation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: affirmations_path,
                    flash: { error: 'Daily Affirmation not found' })
    end

    def affirmation_params
      params.require(:affirmation).permit(:text, :scheduled_date)
    end

    def success(action)
      redirect_to affirmations_path, flash: { success: "Daily Affirmation was successfully #{action}" }
    end

    def update_unique_check
      date = affirmation_params[:scheduled_date]

      return unless Affirmation.where('id != ? and scheduled_date = ?', @affirmation.id, date).present?

      redirect_back(fallback_location: affirmation_path(@affirmation), flash: error('update'))
    end

    def create_unique_check
      return unless Affirmation.where('scheduled_date = ?', affirmation_params[:scheduled_date]).present?

      session[:affirmation_text] = affirmation_params[:text]

      redirect_back(fallback_location: new_affirmation_path, flash: error('create'))
    end

    def error(action)
      date = Date.parse(affirmation_params[:scheduled_date]).strftime('%d/%m/%Y')

      { error: "Daily Affirmation not #{action}d: an affirmation already exists for #{date}" }
    end

    def clear_session_data
      session.delete(:affirmation_text)
    end

    def affirmations_params
      params.permit(:sort, :direction)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : affirmations_path
      add_breadcrumb('Daily Affirmations', path, 'fas fa-smile')
    end
  end
end
