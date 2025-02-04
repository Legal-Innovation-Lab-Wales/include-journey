# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/survey_responses_controller.rb
  class SurveyResponsesController < SurveyApplicationController
    skip_before_action :editable
    before_action :set_breadcrumbs
    include Pagination

    # GET /survey/:survey_id/survey_responses
    def index
      render 'index'
    end

    # GET /survey/:survey_id/survey_responses/:survey_response_id
    def show
      add_breadcrumb(@survey_response.user.full_name)
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
      @sort = pagination_params[:sort].presence || 'submitted_at'
      {@sort => @direction}
    end

    def set_breadcrumbs
      add_breadcrumb('Surveys', surveys_path, 'fas fa-clipboard-list')
      add_breadcrumb(@survey.name, survey_path(@survey))
      path = action_name == 'index' ? nil : survey_response_index_path(@survey)
      add_breadcrumb('Responses', path)
    end
  end
end
