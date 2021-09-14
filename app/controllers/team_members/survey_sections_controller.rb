module TeamMembers
  # app/controllers/team_members/survey_sections_controller.rb
  class SurveySectionsController < SurveyApplicationController

    # POST /surveys/:survey_id/survey_sections
    def create
      @survey_section = @survey.survey_sections.create!(order: @survey.next_section)

      redirect_to edit_survey_path(@survey, anchor: "section[#{@survey_section.id}]")
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id
    def update
      @survey_section.update!(section_params)

      respond_to do |format|
        format.json { render json: @survey_section.as_json, status: :ok }
      end
    end

    # PUT /surveys/:survey_id/survey_sections/:section_id/reorder
    def reorder
      reorder_params[:questions].each_with_index { |id, i| order(@survey_section.survey_questions, id, i) }
      reorder_params[:comment_sections].each_with_index { |id, i| order(@survey_section.survey_comment_sections, id, i) }

      respond_to do |format|
        format.json { render json: @survey_section.as_json, status: :ok }
      end
    end

    # DELETE /surveys/:survey_id/survey_sections/:section_id
    def destroy
      @survey_section.destroy!

      redirect_back(fallback_location: edit_survey_path(@survey), flash: { success: 'Section removed' })
    end

    private

    def order(resources, id, index)
      resources.find(id).update!(order: index + 1)
    end

    def section_params
      params.require(:survey_section).permit(:heading)
    end

    def reorder_params
      params.require(:survey_section).permit(questions: [], comment_sections: [])
    end
  end
end
