module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class ChildFoldersController < ApplicationController
    before_action :current_parent_folder
    before_action :set_breadcrumbs
    before_action :new_child_folder, only: %i[index]
    before_action :child_folder_params, only: %i[create update]
    include Pagination

    def create
      @child_folder = new_child_folder
      @child_folder.name = child_folder_params[:name]
      @child_folder.parent_folder_id = child_folders_params[:folder_id]
      if @child_folder.save
        redirect_to user_folder_children_path(@user), flash: { notice: 'Successfully created folder!' }
      else
        redirect_to user_folder_children_path(@user), flash: { error: 'Folder not created. Please only use standard
                                                                characters and punctuation' }
      end
    end

    protected

    def resources
      current_team_member.folders.where(parent_folder_id: @current_parent_folder.id)
    end

    def resources_per_page
      12
    end

    def search
      resources.where(child_folder_search, wildcard_query)
    end

    private

    def child_folder_params
      params.require(:folder).permit(:name)
    end

    def child_folders_params
      params.permit(:query, :limit, :user_id, :folder_id, :folder, :commit, :authenticity_token)
    end

    def current_parent_folder
      @current_parent_folder = Folder.find(child_folders_params[:folder_id])
    end

    def user
      @user = User.find(child_folders_params[:user_id])
    end

    def child_folder_search
      'lower(name) similar to lower(:query)'
    end

    def new_child_folder
      @new_child_folder = current_team_member.folders.new
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-users')
      add_breadcrumb(user.full_name, user_path(user), 'fas fa-user')
      add_breadcrumb('Files', user_uploads_path, 'fas fa-file')
      add_breadcrumb('My Folders', user_folders_path, 'fas fa-folder') unless action_name != 'index'
      store_folder_tree.each do |folder|
        if folder == store_folder_tree[-1]
          add_breadcrumb(folder.name, nil, 'fas fa-folder')
        else
          add_breadcrumb(folder.name, user_folder_children_path(folder_id: folder.id), 'fas fa-folder')
        end
      end
    end

    def find_folder(id)
      Folder.find(id)
    end

    def store_folder_tree
      folder_arr = [@current_parent_folder]
      child_folder = @current_parent_folder
      until child_folder.parent_folder_id.nil?
        parent_folder = find_folder(child_folder.parent_folder_id)
        folder_arr.unshift(parent_folder)
        child_folder = parent_folder
      end

      folder_arr
    end
  end
end
