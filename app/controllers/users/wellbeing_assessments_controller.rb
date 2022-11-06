module Users
  # app/controllers/users/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < UsersApplicationController
    before_action :wellbeing_assessment, only: :show

    before_action :wellbeing_metrics, only: %i[new create]
    before_action :wellbeing_assessment_today?, :new_wellbeing_assessment, :last_wellbeing_assessment, only: :new
    before_action :last_scores, only: :new, if: -> { @last_wellbeing_assessment.present? }

    before_action :wba_params, only: :create
    after_action :wba_scores, only: :create

    before_action :wellbeing_services, only: %i[new show]

    # GET /wellbeing_assessments/:id
    def show
      add_breadcrumb('My Needs', nil, 'fas fa-heart')
      render 'show'
    end

    # GET /wellbeing_assessments/new
    def new
      add_breadcrumb('My Needs', nil, 'fas fa-heart')
      render 'new'
    end

    # POST /wellbeing_assessments/create
    def create
      if (@wellbeing_assessment = current_user.wellbeing_assessments.create!)
        redirect_to wellbeing_assessment_path(@wellbeing_assessment)
      else
        redirect_to authenticated_user_root_path,
                    error: "Wellbeing assessment could not be created: #{@wellbeing_assessment.errors}"
      end
    end

    protected

    def last_wellbeing_assessment
      @last_wellbeing_assessment = current_user.last_wellbeing_assessment
    end

    private

    def wellbeing_assessment_today?
      wellbeing_assessment_today = current_user.wellbeing_assessment_today

      return unless wellbeing_assessment_today.present?

      redirect_to wellbeing_assessment_path(wellbeing_assessment_today),
                  notice: 'The below wellbeing assessment was completed today'
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

    def last_scores
      @last_scores = @last_wellbeing_assessment.wba_scores.collect do |wba_score|
        { id: wba_score.wellbeing_metric_id, value: wba_score.value }
      end
    end

    def new_wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.new
    end

    def wellbeing_assessment
      @wellbeing_assessment = current_user.wellbeing_assessments.includes(:wba_scores).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_wellbeing_assessment_path, error: 'No such wellbeing assessment could be found'
    end

    def wba_params
      params.require(:wellbeing_assessment).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def wellbeing_services
      @wellbeing_services = WellbeingService.includes(:wellbeing_metrics).all
    end
  end
end
