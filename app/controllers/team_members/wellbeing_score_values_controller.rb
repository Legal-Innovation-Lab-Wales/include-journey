module TeamMembers
  # app/controllers/team_members/wellbeing_score_values_controller.rb
  class WellbeingScoreValuesController < TeamMembersApplicationController
    before_action :set_breadcrumbs
    # GET /wellbeing_score_values
    def index
      @score_values = WellbeingScoreValue.all.order(:id)
      render 'index'
    end

    # PUT /wellbeing_score_values/:id
    def update
      @score_values = WellbeingScoreValue.find(params[:id])
      flash = if @score_values.update(wellbeing_score_params)
        {success: 'Wellbeing Score values updated'}
      else
        {error: 'Wellbeing score values not updated. Please only use characters A-Z'}
      end
      redirect_to(wellbeing_score_values_path, flash: flash)
    end

    private

    def wellbeing_score_params
      params.require(:wellbeing_score_value)
        .permit(:name)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : wellbeing_score_values_path
      add_breadcrumb('Wellbeing Management', path, 'fas fa-tools')
    end
  end
end
