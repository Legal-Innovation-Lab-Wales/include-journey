module TeamMembers
  # app/controllers/team_members/wellbeing_score_values_controller.rb
  class WellbeingScoreValuesController < TeamMembersApplicationController
    # GET /wellbeing_score_values
    def index
      @score_values = WellbeingScoreValue.all
      render 'index'
    end

    # PUT /wellbeing_score_values/:id
    def update
    end

    private

    def wellbeing_metric_params
      # params.require()
    end
  end
end
