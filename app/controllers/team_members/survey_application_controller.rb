module TeamMembers
  # app/controllers/team_members/survey_application_controller.rb
  class SurveyApplicationController < TeamMembersApplicationController
    before_action :survey, if: -> { params[:survey_id].present? }
    before_action :editable, if: -> { @survey.present? }
    before_action :survey_section, if: -> { @survey.present? && params[:section_id].present? }
    before_action :survey_question, if: -> { @survey_section.present? && params[:question_id].present? }
    before_action :survey_comment_section, if: -> { @survey_section.present? && params[:comment_section_id].present? }

    protected

    def editable
      return unless @responses.present? && !@responses.count.zero?

      redirect_back(fallback_location: surveys_path, flash: { error: 'You cannot edit a Survey which has responses' })
    end

    def survey
      @survey = Survey.includes(:survey_sections, :survey_responses)
                      .find(params[:survey_id])
      @survey_sections = @survey.survey_sections.includes(:survey_questions, :survey_comment_sections)
      @responses = @survey.survey_responses
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: surveys_path, flash: { error: 'Survey not found' })
    end

    def survey_section
      @survey_section = @survey_sections.find(params[:section_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Section not found' })
    end

    def survey_question
      @survey_question = @survey_section.survey_questions.find(params[:question_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Question not found' })
    end

    def survey_comment_section
      @survey_comment_section = @survey_section.survey_comment_sections.find(params[:comment_section_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Comment Section not found' })
    end
  end
end
