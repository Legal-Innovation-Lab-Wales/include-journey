module TeamMembers
  # app/controllers/team_members/occupational_therapist_assessments_controller.rb
  class OccupationalTherapistAssessmentsController < ApplicationController
    before_action :check_organization
    before_action :index_breadcrumbs, only: :index
    before_action :user
    before_action :team_member, :occupational_therapist_assessments, only: :index
    before_action :occupational_therapist_metrics, only: %i[new create]
    before_action :occupational_therapist_scores, only: %i[new create]
    before_action :ensure_ota_present, only: :ota_params
    before_action :ota_metric_values_in_params, only: %i[new create]
    include Pagination
    rescue_from ActionController::ParameterMissing, with: :handle_missing_ota_assessment

    def index; end

    def show
      add_breadcrumb('Occupational Therapist Assessments', occupational_therapist_assessments_path, 'fas fa-list')
      add_breadcrumb('This Occupational Therapist Assessment')
      @occupational_therapist_assessment = OccupationalTherapistAssessment.includes(:user, :team_member).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))

      render 'show'
    end

    def new
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(user.full_name, user_path(user))
      add_breadcrumb('New Occupational Therapist Assessment', nil, 'fas fa-plus-circle')

      @occupational_therapist_assessment = OccupationalTherapistAssessment.new

      render 'new'
    end

    def create
      @occupational_therapist_assessment = current_team_member.occupational_therapist_assessments.new(user: @user)

      # Initialize an array to store validation errors
      errors = []

      @occupational_therapist_metrics.each do |metric|
        value = ota_params["ot_metric_#{metric.id}"]
        if value.nil?
          errors << "Occupational therapist assessment could not be created: #{@occupational_therapist_assessment.errors}"
        else
          @occupational_therapist_assessment.ota_entries.new(
            occupational_therapist_metric: ot_metric(metric.name),
            occupational_therapist_score: ot_score(value)
          )
        end
      end

      if errors.any?
        # If there are errors, render the form with validation errors
        flash[:error] = 'You submitted an incomplete form!'
        render :new, status: :unprocessable_entity
      else
        # If no errors, try to save the assessment
        if @occupational_therapist_assessment.save
          flash[:success] = 'Occupational Therapist Assessment Successful!'
          redirect_to occupational_therapist_assessment_path(@occupational_therapist_assessment)
        else
          # If there are errors during save, render the form with errors
          flash[:error] = 'Occupational therapist assessment could not be created.'
          render :new, status: :unprocessable_entity
        end
      end
    end

    protected

    def resources
      @occupational_therapist_assessments.order(created_at: :desc)
    end

    def resources_per_page
      10
    end

    def search
      @occupational_therapist_assessments.where(user_search, wildcard_query)
                                         .order(created_at: :desc)
    end

    private

    def occupational_therapist_assessment
      @occupational_therapist_assessment = OccupationTherapistAssessment.includes(:user, :team_member)
                                                                        .find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
    end

    def occupational_therapist_assessments
      @occupational_therapist_assessments =
        if @team_member.present?
          @team_member.occupational_therapist_assessments.joins(:user).where({"users.deleted": false}).includes(:user, :ota_entries)
        elsif @user.present?
          @user.occupational_therapist_assessments.includes(:team_member, :ota_entries)
        else
          OccupationalTherapistAssessment.joins(:user).where({"users.deleted": false}).includes(:user, :team_member, :ota_entries)
        end
    end

    def occupational_therapist_metrics
      @occupational_therapist_metrics = OccupationalTherapistMetric.all.order(:created_at)
    end

    def occupational_therapist_scores
      @occupational_therapist_scores = OccupationalTherapistScore.all.order(:created_at)
    end

    def user
      return unless params[:user_id].present?

      @user = User.includes(:occupational_therapist_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:occupational_therapist_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:team_member_id]))
    end

    def ota_params
      params.require(:occupational_therapist_assessment).permit(@occupational_therapist_metrics.map { |metric| "ot_metric_#{metric.id}" })
    end

    def ota_metric_values_in_params
      (1..occupational_therapist_metrics.count).each do |i|
        instance_variable_set("@ot_metric_#{i}_value", params.dig(:occupational_therapist_assessment, "ot_metric_#{i}"))
      end
    end

    def ot_metric(name)
      OccupationalTherapistMetric.find_by(name: name)
    end

    def ot_score(value)
      OccupationalTherapistScore.find_by(value: value)
    end

    def handle_missing_ota_assessment
      flash[:error] = 'You submitted an empty form!'
      redirect_to new_user_occupational_therapist_assessment_path(@user)
    end

    def index_breadcrumbs
      if user
        add_breadcrumb('Users', users_path, 'fas fa-user')
        add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      elsif team_member
        add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
        add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
      end
      add_breadcrumb('Occupational Therapist Assessments', nil, 'fas fa-list')
    end

    def subheading_stats
      @count_in_last_week = @resources.where('occupational_therapist_assessments.created_at >= ?', 1.week.ago).size
      @count_in_last_month = @resources.where('occupational_therapist_assessments.created_at >= ?', 1.month.ago).size
      return unless @user

      @count_by_team_member = @resources.count { |ota| ota.team_member_id.present? }
      @count_by_user = @resources.count { |ota| ota.team_member_id.nil? }
    end

    def check_organization
      return if ENV['ORGANISATION_NAME'] == 'wallich-journey'

      flash[:error] = 'Sorry, you can\'t access that.'
      redirect_to root_path
    end
  end
end
