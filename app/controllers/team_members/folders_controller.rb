module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class FoldersController < ApplicationController
    before_action :set_breadcrumbs
    before_action :new_folder, only: %i[index]
    before_action :folder_params, only: %i[create update]
    include Pagination

    def create
      @folder = new_folder
      @folder.name = folder_params[:name]
      if @folder.save
        redirect_to user_folders_path(@user), flash: { notice: 'Successfully created folder!' }
      else
        redirect_to user_folders_path(@user), flash: { error: 'Folder not created. Please only use standard
                                                                characters and punctuation' }
      end
    end

    protected

    def resources
      current_team_member.folders.where(parent_folder: nil)
    end

    def resources_per_page
      12
    end

    def search
      resources.where(folder_search, wildcard_query)
    end

    private

    def folder_params
      params.require(:folder).permit(:name)
    end

    def folder
      @folder = Folder.find(params[:id])
    end

    def user
      @user = User.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
    end

    def folder_search
      'lower(name) similar to lower(:query)'
    end

    def new_folder
      @new_folder = current_team_member.folders.new
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-users')
      add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      add_breadcrumb('Files', user_uploads_path, 'fas fa-file')

      add_breadcrumb('My Folders', nil, 'fas fa-folder') unless action_name != 'index'
    end
  end
end
