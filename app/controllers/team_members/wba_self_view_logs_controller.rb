module TeamMembers
  # app/controllers/team_members/wba_self_view_logs_controller.rb
  class WbaSelfViewLogsController < AdminApplicationController
    before_action :team_member, only: %i[index page_index]
    before_action :page, :offset, :wba_self_view_logs, only: :page_index
    before_action :count, :last_page, only: :page_index, if: -> { @wba_self_view_logs.present? }
    before_action :redirect, only: :page_index, unless: -> { @wba_self_view_logs.present? }

    LIMIT = 5

    # GET /team_members/:team_member_id/wba_self_view_logs
    def index
      redirect_to pages_team_member_wba_self_view_logs_path(@team_member, 1)
    end

    # GET /team_members/:team_member_id/wba_self_view_logs/page/:page_number
    def page_index
      render 'index'
    end

    private

    def count
      @count = @team_member.wba_self_view_logs.count
    end

    def last_page
      @last_page = @offset + LIMIT >= @count
    end

    def offset
      @offset = @page * LIMIT
    end

    def page
      @page = params[:page_number].to_i

      return if @page.positive?

      redirect_to pages_team_member_wba_self_view_logs_path(@team_member, 1), alert: 'Page number cannot be below 1'
    end

    def team_member
      @team_member = TeamMember.includes(:wba_self_view_logs).find(params[:team_member_id])
    end

    def wba_self_view_logs
      @wba_self_view_logs = @team_member.wba_self_view_logs.includes(:user).offset(@offset).limit(LIMIT).order(created_at: :desc)
    end

    def redirect
      redirect_to team_member_path(@team_member), alert: 'No WBA self view logs found'
    end
  end
end
