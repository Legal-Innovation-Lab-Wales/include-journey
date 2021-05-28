module TeamMembers
  # app/controllers/team_members/wellbeing_score_values_controller.rb
  class WellbeingScoreValuesController < TeamMembersApplicationController
    # GET /wellbeing_score_values
    def index
      @score_values = WellbeingScoreValue.all.order(:value)
      render 'index'
    end

    # PUT /wellbeing_score_values/:id
    def update
      @score_values = WellbeingScoreValue.find(params[:id])
      if @score_values.update(wellbeing_score_params)
        redirect_to wellbeing_score_values_path, flash: { success: "Wellbeing Score values updated"}
      else
        redirect_to wellbeing_score_values_path, flash: { error: "Wellbeing score values not updated. Please try again"}
      end
    end

    private

    def wellbeing_score_params
      params.require(:wellbeing_score_value).permit(:name)
    end
  end
end
