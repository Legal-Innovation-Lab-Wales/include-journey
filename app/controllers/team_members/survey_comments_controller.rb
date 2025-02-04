# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/survey_comments_controller.rb
  class SurveyCommentsController < SurveyApplicationController
    skip_before_action :editable
    before_action :set_breadcrumbs
    include Pagination

    # GET /surveys/:survey_id/survey_sections/:survey_section_id/survey_comment_sections/:survey_comment_section_id
    def index
      render 'index'
    end

    protected

    def resources
      @survey_comment_section.survey_comments
        .includes(:user)
        .order(sort)
    end

    def search
      @survey_comment_section.survey_comments
        .includes(:user)
        .joins(:user)
        .where(comment_search, wildcard_query)
        .order(sort)
    end

    def sort
      @sort = pagination_params[:sort].presence || 'created_at'
      {@sort => @direction}
    end

    private

    def comment_search
      "#{user_search} or lower(survey_comments.text) similar to lower(:query)"
    end

    def set_breadcrumbs
      add_breadcrumb('Surveys', surveys_path, 'fas fa-clipboard-list')
      add_breadcrumb(@survey.name, survey_path(@survey))
      path = action_name == 'index' ? nil : survey_response_index_path(@survey)
      add_breadcrumb('Comments', path)
    end
  end
end
