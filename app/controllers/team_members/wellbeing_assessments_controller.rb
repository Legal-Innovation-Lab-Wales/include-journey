module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < TeamMembersApplicationController
    before_action :index_breadcrumbs, only: :index
    before_action :user, except: :show
    before_action :wba_values, only: :index
    before_action :team_member, :wellbeing_assessments, only: %i[index export]
    include Pagination
    include Exportable

    before_action :wellbeing_metrics, only: %i[new create]
    before_action :wba_params, only: :create
    after_action :wba_scores, only: :create

    # GET /wellbeing_assessments
    # GET /team_members/:team_member_id/wellbeing_assessments
    # GET /users/:user_id/wellbeing_assessments
    def index; end

    # GET /wellbeing_assessments/export
    # GET /team_members/:team_member_id/wellbeing_assessments/export
    # GET /users/:user_id/wellbeing_assessments/export
    def export; end

    # GET /wellbeing_assessments/:id
    def show
      add_breadcrumb('Wellbeing Assessments', wellbeing_assessments_path, 'fas fa-heart')
      add_breadcrumb('This Wellbeing Assessment')
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))

      render 'show'
    end

    # GET /users/:user_id/wellbeing_assessments/new
    def new
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(user.full_name, user_path(user))
      add_breadcrumb("New Wellbeing Assessment", nil, 'fas fa-plus-circle')

      wellbeing_assessment_today
      last_scores
      @wellbeing_assessment = WellbeingAssessment.new

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

    protected

    def resources
      @wellbeing_assessments.order(created_at: :desc)
    end

    def resources_per_page
      @user.present? ? 20 : 6
    end

    def search
      @wellbeing_assessments.joins(:user)
                            .where(user_search, wildcard_query)
                            .order(created_at: :desc)
    end

    def base_path
      'wellbeing-assessments'
    end

    private

    def last_scores
      last_wellbeing_assessment = @user.last_wellbeing_assessment

      return unless last_wellbeing_assessment.present?

      @last_scores = last_wellbeing_assessment.wba_scores.collect do |wba_score|
        { id: wba_score.wellbeing_metric_id, value: wba_score.value }
      end
    end

    def new_wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.new
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:wellbeing_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:team_member_id]))
    end

    def user
      return unless params[:user_id].present?

      @user = User.includes(:wellbeing_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def wba_params
      params.require(:wellbeing_assessment).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def wba_scores
      total = 0.0
      @wellbeing_metrics.each do |metric|
        value = wba_params["wellbeing_metric_#{metric.id}"]
        @wellbeing_assessment.wba_scores.create!({ wellbeing_metric: metric,
                                                   value: value })
        total += value.to_f
      end
      @wellbeing_assessment.update!(average: total / @wellbeing_metrics.count)
    end

    def wba_values
      return unless @user.present?

      @wba_values = [''] + WellbeingScoreValue.order(id: :asc).pluck(:name)
    end

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
    end

    def wellbeing_assessments
      @wellbeing_assessments =
        if @team_member.present?
          @team_member.wellbeing_assessments.joins(:user).where({"user.deleted": false}).includes(:user, wba_scores: :wellbeing_metric)
        elsif @user.present?
          @user.wellbeing_assessments.includes(:team_member, wba_scores: :wellbeing_metric)
        else
          WellbeingAssessment.joins(:user).where({"user.deleted": false}).includes(:user, :team_member, wba_scores: :wellbeing_metric)
        end
    end

    def wellbeing_assessment_today
      wellbeing_assessment_today = @user.wellbeing_assessment_today

      return unless wellbeing_assessment_today.present?

      redirect_to wellbeing_assessment_path(wellbeing_assessment_today),
                  notice: 'The below wellbeing assessment was completed today'
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all.order(:created_at)
    end

    def subheading_stats
      @count_in_last_week = @resources.where('wellbeing_assessments.created_at >= ?', 1.week.ago).size
      @count_in_last_month = @resources.where('wellbeing_assessments.created_at >= ?', 1.month.ago).size
      return unless @user

      @count_by_team_member = @resources.count { |wba| wba.team_member_id.present? }
      @count_by_user = @resources.count { |wba| wba.team_member_id.nil? }
    end

    def index_breadcrumbs
      if user
        add_breadcrumb('Users', users_path, 'fas fa-user')
        add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      elsif team_member
        add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
        add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
      end
      add_breadcrumb('Wellbeing Assessments', nil, 'fas fa-heart')
    end
  end
end
