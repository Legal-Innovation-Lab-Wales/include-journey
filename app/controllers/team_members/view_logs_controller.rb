module TeamMembers
  # app/controllers/team_members/view_logs_controller.rb
  class ViewLogsController < AdminApplicationController
    before_action :team_member, only: %i[index show]
    before_action :page, :offset, :resources, :view_logs, only: :show
    before_action :count, :last_page, only: :show, if: -> { @view_logs.present? }
    before_action :redirect, only: :show, unless: -> { @view_logs.present? }

    VIEW_LOGS_PER_PAGE = 5

    def index
      redirect_to view_log_path
    end

    def show
      render 'show'
    end

    protected

    def count
      @count = @resources.count
    end

    def last_page
      @last_page = @offset + VIEW_LOGS_PER_PAGE >= @count
    end

    def offset
      @offset = (@page - 1) * VIEW_LOGS_PER_PAGE
    end

    def page
      @page = params[:page_number].to_i
    end

    def resources
      raise 'Subclass has not overridden resources function'
    end

    def team_member
      raise 'Subclass has not overridden view_log_path function'
    end

    def view_logs
      @view_logs = @resources.offset(@offset).limit(VIEW_LOGS_PER_PAGE).order(created_at: :desc)
    end

    def redirect
      redirect_back(fallback_location: root_path, alert: 'No view logs found')
    end
  end
end
