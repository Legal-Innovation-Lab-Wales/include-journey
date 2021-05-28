module TeamMembers
  # app/controllers/team_members/wellbeing_scores_controller.rb
  class WellbeingScoresController < TeamMembersApplicationController
    # GET /wellbeing_scores
    def index
      render 'index'
    end

    # PUT /wellbeing_scores/:id
    def update
    end

    private

    def wellbeing_metric_params
      params.require(:wellbeing_score).permit(:name)
    end
  end
end
