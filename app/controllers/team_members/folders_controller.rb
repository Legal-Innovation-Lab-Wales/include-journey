module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class FoldersController < ApplicationController
    before_action :set_breadcrumbs
    include Pagination

    def index
      @top_folders = Folder.where(parent_folder: nil)
      @top_uploads = Upload.where(parent_folder: nil)
    end

    protected

    def resources
      Folder.where(parent_folder: nil)
    end

    def resources_per_page
      12
    end

    def search
      resources.where(folder_search, wildcard_query)
    end

    private

    def folder
      @folder = Folder.find(params[:id])
    end

    def user
      @user = User.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def folder_search
      'lower(name) similar to lower(:query)'
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-users')
      add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      add_breadcrumb('Files', user_uploads_path, 'fas fa-file')

      add_breadcrumb('My Folders', nil, 'fas fa-folder') unless action_name != 'index'
    end
  end
end
