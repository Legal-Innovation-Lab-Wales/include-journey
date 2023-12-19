module TeamMembers
  # app/controllers/team_members/occupational_therapist_assessments_controller.rb
  class OccupationalTherapistAssessmentsController < ApplicationController
    before_action :user
    before_action :team_member, :occupational_therapist_assessments, only: :index
    include Pagination

    before_action :occupational_therapist_metrics, only: %i[new create]
    before_action :occupational_therapist_scores, only: :new
    before_action :ota_params, only: :create
    after_action :ota_scores, only: :create

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
      add_breadcrumb('New Occupatioanl Therapist Assessment', nil, 'fas fa-plus-circle')

      @occupational_therapist_assessment = OccupationalTherapistAssessment.new

      render 'new'
    end

    def create
      # fail
      if (@occupational_therapist_assessment = current_team_member.occupational_therapist_assessments.create!(user: @user))
        redirect_to occupational_therapist_assessment_path(@occupational_therapist_assessment)
      else
        redirect_to authenticated_team_member_root_path,
                    error: "Occupational therapist assessment could not be created: #{@occupational_therapist_assessment.errors}"
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
      @occupational_therapist_assessments.joins(:user)
                                         .where(user_search, wildcard_query)
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
          @team_member.occupational_therapist_assessments.joins(:user).where({"user.deleted": false}).includes(:user, :ota_entries)
        elsif @user.present?
          @user.occupational_therapist_assessments.includes(:team_member, :ota_entries)
        else
          OccupationalTherapistAssessment.joins(:user).where({"user.deleted": false}).includes(:user, :team_member, :ota_entries)
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

    def ot_metric(name)
      OccupationalTherapistMetric.find_by(name: name)
    end

    def ot_score(value)
      OccupationalTherapistScore.find_by(value: value)
    end

    def ota_scores
      puts 'ANSWER'
      @occupational_therapist_metrics.each do |metric|
        value = ota_params["ot_metric_#{metric.id}"]
        @occupational_therapist_assessment.ota_entries.create!(
          occupational_therapist_metric: ot_metric(metric.name),
          occupational_therapist_score: ot_score(value)
        )
      end
    end
  end
end
