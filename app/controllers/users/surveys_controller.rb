# frozen_string_literal: true

module Users
  # app/controllers/users/surveys_controller.rb
  class SurveysController < UsersApplicationController
    before_action :survey, except: :index
    before_action :set_breadcrumbs

    # GET /surveys
    def index
      @surveys = Survey.available
      @survey_responses = current_user.survey_responses.includes(:survey)

      if one_survey_available?
        redirect_to survey_path(@surveys.first)
      else
        render 'index'
      end
    end

    # GET /surveys/:id
    def show
      add_breadcrumb(@survey.name, nil, 'fas fa-clipboard-list')
      render 'show'
    end

    # PUT /surveys/:id
    def update
      return if @survey_response.submitted?

      @errors = false
      update_answers
      update_comments
      if @errors
        add_breadcrumb(@survey.name, nil, 'fas fa-clipboard-list')
        flash.now[:alert] = 'Failed to save: Please only use standard characters and punctuation'
        render 'show', status: :unprocessable_entity
      elsif params[:partial].present? && params[:partial] == 'true'
        respond_to do |format|
          format.json { render json: @survey_response.as_json, status: :ok }
        end
      else
        mark_submitted
      end
    end

    private

    def survey
      @survey = Survey.includes(:survey_sections)
        .find(ActiveRecord::Base.sanitize_sql_for_conditions(params[:id]))
      @survey_sections = @survey.survey_sections
        .includes(:survey_questions, :survey_comment_sections)
        .order(order: :asc)
      @survey_response = SurveyResponse.find_or_create_by!(
        user: current_user,
        survey: @survey,
      )
    end

    def update_answers
      return if params[:question].blank?

      params[:question].each do |question|
        answer = SurveyAnswer.find_or_create_by(
          survey_response: @survey_response,
          survey_question: SurveyQuestion.find(question[0]),
        )
        unless answer.update(answer: question[1])
          @errors = true
        end
      end
    end

    def update_comments
      return if params[:comment_section].blank?

      params[:comment_section].each do |comment_section|
        comment = SurveyComment.find_or_create_by(
          survey_response: @survey_response,
          survey_comment_section: SurveyCommentSection.find(comment_section[0]),
        )
        unless comment.update(text: comment_section[1])
          @errors = true
        end
      end
    end

    def one_survey_available?
      return false unless @surveys.count == 1

      response = @survey_responses.where(survey_id: @surveys.first.id)

      response.blank? || !response.first.submitted?
    end

    def mark_submitted
      @survey_response.update(submitted_at: Time.current)

      redirect_to(
        authenticated_user_root_path,
        flash: {success: "Thank You! (#{@survey.name}) was successfully submitted."},
      )
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : surveys_path
      add_breadcrumb('My Voice', path, 'fas fa-comments')
    end
  end
end
