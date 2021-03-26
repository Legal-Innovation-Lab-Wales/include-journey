module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < TeamMembersApplicationController
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

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])
    end
  end
end
