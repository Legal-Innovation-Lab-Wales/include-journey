module TeamMembers
  # app/controllers/team_members/surveys_controller.rb
  class SurveysController < TeamMembersApplicationController
    before_action :survey, except: %i[index new create]
    include Pagination

    # GET /surveys
    def index
      render 'index'
    end

    # GET /surveys/new
    def new
      render 'new'
    end

    # POST /surveys
    def create
      puts 'Create action called...'
    end

    # GET /surveys/:id
    def show
      render 'show'
    end

    # GET /surveys/:id/edit
    def edit
      render 'edit'
    end

    # PUT /surveys/:id
    def update
      puts 'Update action called...'
    end

    # DELETE /surveys/:id
    def destroy
      puts 'Destroy action called...'
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

    def survey
      @survey = Survey.includes(:survey_sections,
                                :survey_questions,
                                :survey_comment_sections,
                                :survey_responses)
                      .find(params[:id])
    end

    def survey_search
      search = 'lower(team_members.first_name) similar to lower(:query)'
      search += ' or lower(team_members.last_name) similar to lower(:query)'
      search += ' or lower(name) similar to lower(:query)'

      search
    end
  end
end
