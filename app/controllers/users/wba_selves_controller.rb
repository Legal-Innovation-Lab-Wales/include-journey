module Users
  # app/controllers/users/wba_selves_controller.rb
  class WbaSelvesController < UsersApplicationController
    before_action :wellbeing_metrics
    before_action :wba_self, :check_user, only: :show

    before_action :check_wba_self_today, :new_wba_self, :last_wba_self, only: :new
    before_action :last_scores, only: :new, if: -> { @last_wba_self.present? }

    before_action :wba_selves_params, only: :create
    after_action :create_wba_self_scores, only: :create

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
      if (@wba_self = current_user.wba_selves.create!({ user_id: current_user.id }))
        redirect_to new_wba_self_wba_self_permission_path(@wba_self)
      else
        render @wba_self.errors, status: :unprocessable_entity
      end
    end

    protected

    def last_wba_self
      @last_wba_self = current_user.wba_selves.includes(:wba_self_scores).last
    end

    def last_score(wellbeing_metric_id)
      return 6 unless @last_scores.present?

      @last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
    end

    helper_method :last_score

    private

    def check_user
      return if @wba_self.user == current_user

      redirect_to authenticated_user_root_path, alert: 'That wellbeing assessment does not belong to you'
    end

    def check_wba_self_today
      wba_self_today = current_user.wba_self_today

      return unless wba_self_today.present?

      redirect_to wba_self_path(wba_self_today)
    end

    def create_wba_self_scores
      @wellbeing_metrics.each do |metric|
        WbaSelfScore.create!({ wba_self_id: @wba_self.id, wellbeing_metric_id: metric.id,
                               value: wba_selves_params["wellbeing_metric_#{metric.id}".to_sym] })
      end
    end

    def last_scores
      @last_scores = @last_wba_self.wba_self_scores.collect { |wba_self_score| { id: wba_self_score.wellbeing_metric_id, value: wba_self_score.value }}
    end

    def new_wba_self
      @wba_self = WbaSelf.new
    end

    def wba_self
      @wba_self = WbaSelf.includes(:wba_self_scores).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to new_wba_self_path, alert: 'No such wellbeing assessment could be found'
    end

    def wba_selves_params
      params.require(:wba_self).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}".to_sym })
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
