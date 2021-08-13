module TeamMembers
  # app/controllers/team_members/survey_comments_controller.rb
  class SurveyCommentsController < SurveyApplicationController
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
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'created_at'
      { "#{@sort}": @direction }
    end

    private

    def comment_search
      "#{user_search} or lower(survey_comments.text) similar to lower(:query)"
    end
  end
end
