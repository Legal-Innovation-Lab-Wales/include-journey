module TeamMembers
  # app/controllers/team_members/survey_questions_controller.rb
  class SurveyQuestionsController < SurveyApplicationController

    # POST /surveys/:survey_id/survey_sections/:section_id/survey_questions
    def create
      @survey_section.survey_questions.create!(order: @survey_section.next_question)

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'New Question added' })
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def update
      @survey_question.update!(question_params)

      respond_to do |format|
        format.json { render json: @survey_question.as_json, status: :ok }
      end
    end

    # DELETE /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def destroy
      @survey_question.destroy!

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'Question removed' })
    end

    private

    def question_params
      params.require(:survey_question).permit(:question)
    end
  end
end
