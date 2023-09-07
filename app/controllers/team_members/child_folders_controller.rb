module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class ChildFoldersController < ApplicationController
    before_action :set_breadcrumbs
    include Pagination

    def index
    end

    protected

    def resources
      Folder.where.not(parent_folder: nil)
    end

    def resources_per_page
      12
    end

    def search
      resources.where(child_folder_search, wildcard_query)
    end

    private

    def child_folder
      @folder = Folder.find(params[:id])
    end

    def parent_folder
      @parent_folder = Folder.find(params[:folder_id])
    end

    def user
      @user = User.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def child_folder_search
      'lower(name) similar to lower(:query)'
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-users')
      add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      add_breadcrumb('Files', user_uploads_path, 'fas fa-file')
      add_breadcrumb('My Folders', nil, 'fas fa-folder') unless action_name != 'index'

      add_breadcrumb('My Folders', nil, 'fas fa-folder') unless action_name != 'index'
    end
  end
end
