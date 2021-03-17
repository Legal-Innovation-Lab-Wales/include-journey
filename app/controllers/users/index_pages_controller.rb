module Users
  # app/controllers/index_pages_controller.rb
  class IndexPagesController < UsersApplicationController
    before_action :page, :limit, :offset, :resources, :page_resources, only: :index
    before_action :count, :last_page, only: :index, if: -> { @page_resources.present? }
    before_action :redirect, only: :index, unless: -> { @page_resources.present? }

    def index
      render 'index'
    end

    protected

    DEFAULT_LIMIT = 3

    def count
      @count = @resources.count
    end

    def resources
      raise 'Mixin class has not overridden resources function'
    end

    def last_page
      @last_page = @offset + @limit >= @count
    end

    def limit
      @limit = DEFAULT_LIMIT
    end

    def offset
      @offset = (@page - 1) * @limit
    end

    def page
      @page = params[:page_number].to_i
    end

    def page_resources
      @page_resources = @resources.offset(@offset).limit(@limit).order(created_at: :desc)
    end

    def redirect
      redirect_back(fallback_location: root_path, alert: 'No resources found')
    end
  end
end
