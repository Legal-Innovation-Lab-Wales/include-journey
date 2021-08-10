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
      puts 'Update action called...'
    end

    # DELETE /surveys/:survey_id/survey_sections/:id
    def destroy
      @survey_section.destroy!

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'Section removed' })
    end
  end
end
