module TeamMembers
  # app/controllers/team_members/occupational_therapist_assessments_controller.rb
  class OccupationalTherapistAssessmentsController < ApplicationController
    before_action :user
    before_action :team_member, :occupational_therapist_assessments, only: :index
    include Pagination

    def index; end

    def show
      add_breadcrumb('Occupational Therapist Assessments', occupational_therapist_assessments_path, 'fas fa-list')
      add_breadcrumb('This Occupational Therapist Assessment')
      @occupational_therapist_assessment = OccupationalTherapistAssessment.includes(:user, :team_member).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))

      render 'show'
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

    def user
      return unless params[:user_id].present?

      @user = User.includes(:occupational_therapist_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:occupational_therapist_assessments).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:team_member_id]))
    end
  end
end
