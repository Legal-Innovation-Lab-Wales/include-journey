module TeamMembers
  # app/controllers/team_members/surveys_controller.rb
  class SurveysController < TeamMembersApplicationController
    before_action :survey, except: %i[index new create]
    include Pagination

    # GET /surveys
    def index
      render 'index'
    end

    # GET /surveys/new
    def new
      render 'new'
    end

    # POST /surveys
    def create
      puts 'Create action called...'
    end

    # GET /surveys/:id
    def show
      render 'show'
    end

    # GET /surveys/:id/edit
    def edit
      render 'edit'
    end

    # PUT /surveys/:id
    def update
      puts 'Update action called...'
    end

    # DELETE /surveys/:id
    def destroy
      puts 'Destroy action called...'
    end

    protected

    def resources
      @surveys = Survey.includes(:survey_sections, :survey_questions, :survey_comment_sections, :survey_responses)
                       .order(created_at: :desc)
    end

    def search
      self.resources
    end

    private

    def survey
      @survey = Survey.includes(:survey_sections, :survey_questions, :survey_comment_sections, :survey_responses)
                      .find(params[:id])
    end
  end
end
