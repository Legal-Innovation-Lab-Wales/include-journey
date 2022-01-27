module TeamMembers
  # app/controllers/team_members/survey_responses_controller.rb
  class SurveyResponsesController < SurveyApplicationController
    skip_before_action :editable
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
      @responses.includes(:user)
                .order(sort)
    end

    def search
      @responses.includes(:user)
                .joins(:user)
                .where(user_search, wildcard_query)
                .order(sort)
    end

    def sort
      pagination_params_sort = pagination_params[:sort]
      @sort = pagination_params_sort.present? ? pagination_params_sort : 'submitted_at'
      { "#{@sort}": @direction }
    end
  end
end
