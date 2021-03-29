module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < PaginationController
    before_action :wellbeing_assessment, only: :show
    before_action :query_params, :page, :query, :limit, :offset, :admin, :team_member, :resources,
                  :count, :last_page, :limit_resources, :redirect, only: :index

    # GET /wellbeing_assessment/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path, notice: click_notice)
    end

    private

    def click_notice
      user_name = @wellbeing_assessment.user.full_name

      if @wellbeing_assessment.team_member.present?
        team_member_name = @wellbeing_assessment.team_member.full_name

        "WBA for #{user_name} created by #{team_member_name} clicked!"
      else
        "WBA for #{user_name} clicked!"
      end
    end

    def multiple
      @multiple = 6
    end

    def resources
      team_member

      wellbeing_assessments = @team_member.present? ? @team_member.wellbeing_assessments : WellbeingAssessment

      @resources = if @query.present?
                     wellbeing_assessments.includes(:user, :wba_scores).joins(:user).where(user_search, wildcard_query)
                                          .order(:created_at)
                   else
                     wellbeing_assessments.includes(:user, :wba_scores).order(:created_at)
                   end
    end

    def team_member
      return unless params[:team_member_id].present?
      return if @team_member.present?

      if current_team_member.id == params[:team_member_id].to_i
        @team_member = current_team_member
      else
        redirect_back(fallback_location: authenticated_team_member_root_path, notice: 'You cannot view that page')
      end
    end

    def admin
      return unless params[:team_member_id].present?

      @admin = current_team_member.admin?

      return unless @admin

      @team_member = TeamMember.includes(:wellbeing_assessments).find(params[:team_member_id])
    end

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])
    end
  end
end
