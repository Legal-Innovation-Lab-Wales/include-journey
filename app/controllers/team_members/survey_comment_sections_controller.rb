module TeamMembers
  # app/controllers/team_members/survey_comment_sections_controller.rb
  class SurveyCommentSectionsController < SurveyApplicationController
    before_action :verify_section, only: :update

    # POST /surveys/:survey_id/survey_sections/:section_id/survey_comment_sections
    def create
      @survey_comment_section =
        @survey_section.survey_comment_sections.create!(order: @survey_section.next_comment_section)

      redirect_to edit_survey_path(@survey, anchor: "comment-section[#{@survey_comment_section.id}]")
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id/survey_comment_sections/:id
    def update
      @survey_comment_section.update!(comment_section_params)

      respond_to do |format|
        format.json { render json: @survey_comment_section.as_json, status: :ok }
      end
    end

    # DELETE /surveys/:survey_id/survey_sections/:section_id/survey_comment_sections/:id
    def destroy
      @survey_comment_section.destroy!

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'Comment Section removed' })
    end

    private

    def comment_section_params
      params.require(:survey_comment_section).permit(:label, :survey_section_id)
    end

    def verify_section
      return unless comment_section_params[:section_id].present?

      return if @survey_sections.find(comment_section_params[:section_id]).present?

      redirect_back(fallback_location: edit_survey_path(@survey),
                    flash: { error: 'Survey Section does not belong to this Survey' })
    end
  end
end
