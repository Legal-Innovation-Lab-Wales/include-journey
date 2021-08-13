module TeamMembers
  # app/controllers/team_members/survey_responses_controller.rb
  class SurveyResponsesController < SurveyApplicationController
    include Pagination

    # GET /survey/:survey_id/survey_responses
    def index
      render 'index'
    end

    # GET /survey/:survey_id/survey_responses/:survey_response_id
    def show
      render 'show'
    end

    protected

    def resources
      @responses.order(sort)
    end

    def search
      @responses.joins(:user)
                .where(user_search, wildcard_query)
                .order(sort)
    end

    def sort
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'submitted_at'
      { "#{@sort}": @direction }
    end
  end
end
