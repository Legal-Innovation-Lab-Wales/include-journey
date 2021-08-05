module Users
  # app/controllers/users/surveys_controller.rb
  class SurveysController < UsersApplicationController
    before_action :survey, except: :index

    # GET /surveys
    def index
      @surveys = Survey.available

      render 'index'
    end

    # GET /surveys/:id
    def show
      render 'show'
    end

    private

    def survey
      @survey = Survey.includes(:survey_sections)
                      .find(params[:id])

      @survey_sections = @survey.survey_sections
                                .includes(:survey_questions, :survey_comment_sections)
                                .order(order: :asc)
    end
  end
end
