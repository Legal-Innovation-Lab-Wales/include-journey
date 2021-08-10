module TeamMembers
  # app/controllers/team_members/survey_comment_sections_controller.rb
  class SurveyCommentSectionsController < TeamMembersApplicationController
    before_action :survey
    before_action :survey_section
    before_action :survey_comment_section, except: :create

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

    def survey_comment_section
      @survey_comment_section = @survey_section.survey_comment_sections.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Comment Section not found' })
    end
  end
end
