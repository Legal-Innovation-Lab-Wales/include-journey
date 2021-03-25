module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < PaginationController
    before_action :wellbeing_assessment, only: :show

    # GET /wellbeing_assessment/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path, notice: click_notice)
    end

    private

    def click_notice
      user_name = @wellbeing_assessment.user.full_name
      team_member_name = @wellbeing_assessment.team_member.full_name

      "WBA for #{user_name} created by #{team_member_name} clicked!"
    end

    def resources
      @admin = params[:team_member_id].present? && current_team_member.admin?

      team_member

      @resources = if @query.present?
                     @team_member.wellbeing_assessments.includes(:user, :wba_scores)
                                 .joins(:user)
                                 .where('lower(users.first_name) like lower(?) or lower(users.last_name) like lower(?)',
                                        "%#{@query}%", "%#{@query}%")
                                 .order(:created_at)
                   else
                     @team_member.wellbeing_assessments.includes(:user, :wba_scores).order(:created_at)
                   end
    end

    def team_member
      @team_member = current_team_member

      return unless @admin

      @team_member = TeamMember.includes(:wellbeing_assessments).find(params[:team_member_id])
    end

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])
    end
  end
end
