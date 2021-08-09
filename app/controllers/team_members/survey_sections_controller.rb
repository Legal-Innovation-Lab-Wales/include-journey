module TeamMembers
  # app/controllers/team_members/survey_sections_controller.rb
  class SurveySectionsController < TeamMembersApplicationController
    before_action :survey
    before_action :survey_section, except: :create

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
      puts 'Destroy action called...'
    end

    private

    def survey
      @survey = Survey.includes(:survey_sections).find(params[:survey_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: surveys_path, flash: { error: 'Survey not found' })
    end

    def survey_section
      @survey_section = SurveySection.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: edit_survey_path(@survey), flash: { error: 'Survey Section not found' })
    end
  end
end
