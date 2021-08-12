module TeamMembers
  # app/controllers/team_members/surveys_controller.rb
  class SurveysController < SurveyApplicationController
    skip_before_action :editable, except: %i[edit update destroy]
    include Pagination

    # GET /surveys
    def index
      render 'index'
    end

    # GET /surveys/new
    def new
      @survey = Survey.new

      render 'new'
    end

    # POST /surveys
    def create
      @survey = Survey.create!(name: survey_params[:name], start_date: survey_params[:start_date],
                               end_date: survey_params[:end_date], team_member: current_team_member)

      redirect_to surveys_path, flash: { success: "#{@survey.name} was successfully created." }
    end

    # GET /surveys/:survey_id
    def show
      @survey

      render 'show'
    end

    # GET /surveys/:survey_id/edit
    def edit
      render 'edit'
    end

    # PUT /surveys/:survey_id
    def update
      @survey.update!(survey_params)

      respond_to do |format|
        format.json { render json: @survey.as_json, status: :ok }
      end
    end

    # PUT /surveys/:survey_id/reorder
    def reorder
      reorder_params[:sections].each_with_index { |id, i| @survey.survey_sections.find(id).update!(order: i + 1) }

      respond_to do |format|
        format.json { render json: @survey.as_json, status: :ok }
      end
    end

    # DELETE /surveys/:survey_id
    def destroy
      @survey.destroy!

      redirect_back(fallback_location: authenticated_team_member_root_path, flash: { success: 'Survey removed' })
    end

    protected

    def resources
      @surveys = Survey.includes(:team_member,
                                 :survey_sections,
                                 :survey_questions,
                                 :survey_comment_sections,
                                 :survey_responses)
                       .order(sort)
    end

    def search
      @surveys = Survey.includes(:team_member,
                                 :survey_sections,
                                 :survey_questions,
                                 :survey_comment_sections,
                                 :survey_responses)
                       .joins(:team_member)
                       .where(survey_search, wildcard_query)
                       .order(sort)
    end

    def direction
      @direction = %w[asc desc].include?(pagination_params[:direction]) ? pagination_params[:direction] : 'asc'
    end

    def sort
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'end_date'
      { "#{@sort}": @direction }
    end

    private

    def survey_search
      'lower(team_members.first_name) similar to lower(:query) or lower(team_members.last_name) similar to lower(:query) or lower(name) similar to lower(:query)'
    end

    def survey_params
      params.require(:survey).permit(:name, :start_date, :end_date)
    end

    def reorder_params
      params.require(:survey).permit(sections: [])
    end
  end
end
