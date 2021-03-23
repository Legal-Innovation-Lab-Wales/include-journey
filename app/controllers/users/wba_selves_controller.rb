module Users
  # app/controllers/users/wba_selves_controller.rb
  class WbaSelvesController < UsersApplicationController
    before_action :wba_self, only: :show

    before_action :wellbeing_metrics, only: %i[new create]
    before_action :check_wba_self_today, :new_wba_self, :last_wba_self, only: :new
    before_action :last_scores, only: :new, if: -> { @last_wba_self.present? }

    before_action :wba_selves_params, only: :create
    after_action :wba_self_scores, only: :create

    # GET /wba_selves/:id
    def show
      render 'show'
    end

    # GET /wba_selves/new
    def new
      render 'new'
    end

    # POST /wba_selves/create
    def create
      if (@wba_self = current_user.wba_selves.create!)
        redirect_to new_wba_self_permission_path(@wba_self)
      else
        redirect_to authenticated_user_root_path,
                    error: "Wellbeing assessment could not be created: #{@wba_self.errors}"
      end
    end

    protected

    def last_wba_self
      @last_wba_self = current_user.last_wba_self
    end

    private

    def check_wba_self_today
      wba_self_today = current_user.wba_self_today

      return unless wba_self_today.present?

      redirect_to wba_self_path(wba_self_today), notice: 'You completed the below wellbeing assessment today'
    end

    def wba_self_scores
      @wellbeing_metrics.each do |metric|
        @wba_self.wba_self_scores.create!({ wellbeing_metric: metric,
                                            value: wba_selves_params["wellbeing_metric_#{metric.id}"] })
      end
    end

    def last_scores
      @last_scores = @last_wba_self.wba_self_scores.collect do |wba_self_score|
        { id: wba_self_score.wellbeing_metric_id, value: wba_self_score.value }
      end
    end

    def new_wba_self
      @wba_self = WbaSelf.new
    end

    def wba_self
      @wba_self = current_user.wba_selves.includes(:wba_self_scores).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_wba_self_path, error: 'No such wellbeing assessment could be found'
    end

    def wba_selves_params
      params.require(:wba_self).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
