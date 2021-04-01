module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < PaginationController
    before_action :user, :wellbeing_metrics, only: %i[new create]
    before_action :new_wellbeing_assessment, :last_wellbeing_assessment, :last_scores, only: :new
    before_action :wellbeing_assessment, only: :show
    before_action :query_params, :page, :query, :limit, :offset, :admin, :team_member, :resources,
                  :count, :last_page, :limit_resources, :redirect, only: :index

    before_action :wba_params, only: :create
    after_action :wba_scores, only: :create

    # GET /wellbeing_assessments/:id
    def show
      render 'show'
    end

    # GET /users/:user_id/wellbeing_assessments/new
    def new
      render 'new'
    end

    # POST /users/:user_id/wellbeing_assessments
    def create
      if (@wellbeing_assessment = current_team_member.wellbeing_assessments.create!(user: @user))
        redirect_to wellbeing_assessment_path(@wellbeing_assessment)
      else
        redirect_to authenticated_team_member_root_path,
                    error: "Wellbeing assessment could not be created: #{@wellbeing_assessment.errors}"
      end
    end

    private

    def admin
      return unless params[:team_member_id].present?

      @admin = current_team_member.admin?

      return unless @admin

      @team_member = TeamMember.includes(:wellbeing_assessments).find(params[:team_member_id])
    end

    def last_wellbeing_assessment
      @last_wellbeing_assessment = @user.last_wellbeing_assessment
    end

    def last_scores
      @last_scores = @last_wellbeing_assessment.wba_scores.collect do |wba_score|
        { id: wba_score.wellbeing_metric_id, value: wba_score.value }
      end
    end

    def new_wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.new
    end

    def multiple
      @multiple = 6
    end

    def resources
      team_member

      wellbeing_assessments = @team_member.present? ? @team_member.wellbeing_assessments : WellbeingAssessment

      @resources = if @query.present?
                     wellbeing_assessments.includes(:user, :wba_scores).joins(:user).where(user_search, wildcard_query)
                                          .order(created_at: :desc)
                   else
                     wellbeing_assessments.includes(:user, :wba_scores).order(created_at: :desc)
                   end
    end

    def team_member
      return unless params[:team_member_id].present?
      return if @team_member.present?

      if current_team_member.id == params[:team_member_id].to_i
        @team_member = current_team_member
      else
        redirect_back(fallback_location: authenticated_team_member_root_path, notice: 'You cannot view that page')
      end
    end

    def user
      @user = User.find(params[:user_id])
    end

    def wba_params
      params.require(:wellbeing_assessment).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def wba_scores
      @wellbeing_metrics.each do |metric|
        @wellbeing_assessment.wba_scores.create!({ wellbeing_metric: metric,
                                                   value: wba_params["wellbeing_metric_#{metric.id}"] })
      end
    end

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all.order(:created_at)
    end
  end
end
