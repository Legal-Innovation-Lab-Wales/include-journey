module TeamMembers
  # app/controllers/team_members/survey_sections_controller.rb
  class SurveySectionsController < SurveyApplicationController

    # POST /surveys/:survey_id/survey_sections
    def create
      @survey.survey_sections.create!(order: @survey.next_section)

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'New Section added' })
    end

    # PUT /surveys/:survey_id/survey_sections/:id
    def update
      @survey_section.update!(section_params)

      respond_to do |format|
        format.json { render json: @survey_section.as_json, status: :ok }
      end
    end

    # DELETE /surveys/:survey_id/survey_sections/:id
    def destroy
      @survey_section.destroy!

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'Section removed' })
    end

    private

    def section_params
      params.require(:survey_section).permit(:heading)
    end
  end
end
