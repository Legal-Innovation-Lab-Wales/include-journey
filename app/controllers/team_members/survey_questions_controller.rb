module TeamMembers
  # app/controllers/team_members/survey_questions_controller.rb
  class SurveyQuestionsController < TeamMembersApplicationController
    before_action :survey
    before_action :survey_section
    before_action :survey_question, except: :create

    # POST /surveys/:survey_id/survey_sections/:section_id/survey_questions
    def create
      @survey_section.survey_questions.create!(order: @survey_section.next_question)

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'New Question added' })
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def update
      puts 'Update action called...'
    end

    # DELETE /surveys/:survey_id/survey_sections/:section_id/survey_questions/:id
    def destroy
      puts 'Destroy action called...'
    end

    private

    def survey
      @survey = Survey.includes(:survey_sections).find(params[:survey_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: surveys_path, flash: { error: 'Survey not found' })
    end

    def survey_section
      @survey_section = @survey.survey_sections.find(params[:section_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Section not found' })
    end

    def survey_question
      @survey_question = @survey_section.survey_questions.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Question not found' })
    end
  end
end
