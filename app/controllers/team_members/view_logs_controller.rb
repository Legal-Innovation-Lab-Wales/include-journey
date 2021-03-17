module TeamMembers
  # app/controllers/team_members/view_logs_controller.rb
  class ViewLogsController < AdminApplicationController
    before_action :team_member, only: %i[index show]
    before_action :page, :offset, :view_logs, only: :show
    before_action :count, :last_page, only: :show, if: -> { @view_logs.present? }
    before_action :redirect, only: :show, unless: -> { @view_logs.present? }

    LIMIT = 5

    def index
      redirect_to view_log_path
    end

    def show
      render 'show'
    end

    protected

    def count
      raise 'Subclass has not overridden show function'
    end

    def last_page
      @last_page = @offset + LIMIT >= @count
    end

    def offset
      @offset = (@page - 1) * LIMIT
    end

    def page
      @page = params[:page_number].to_i

      return if @page.positive?

      redirect_to view_log_path, alert: 'Page number cannot be below 1'
    end

    def team_member
      raise 'Subclass has not overridden view_log_path function'
    end

    def view_logs
      raise 'Subclass has not overridden view_log_path function'
    end

    def redirect
      redirect_to team_member_path(@team_member), alert: 'No view logs found'
    end

    def view_log_path
      raise 'Subclass has not overridden view_log_path function'
    end
  end
end
