module TeamMembers
  # app/controllers/team_members/survey_comment_sections_controller.rb
  class SurveyCommentSectionsController < SurveyApplicationController

    # POST /surveys/:survey_id/survey_sections/:section_id/survey_comment_sections
    def create
      @survey_section.survey_comment_sections.create!(order: @survey_section.next_comment_section)

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'New Comment Section added' })
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def update
      puts 'Update action called...'
    end

    # DELETE /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def destroy
      puts 'Destroy action called...'
    end
  end
end
