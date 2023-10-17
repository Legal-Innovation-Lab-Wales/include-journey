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
        redirect_to folders_path, flash: { notice: 'Successfully created folder!' }
      else
        redirect_to folders_path, flash: { error: 'Folder not created. Please only use standard
                                                                characters and punctuation' }
      end
    end


    def update
      folder = Folder.find(params[:folder_id])
      updated = false
      if folder.update(name: folder_params[:name])
        updated = true
      end
      
      redirect_back(fallback_location: has_folders ? folders_path : users_path	,
        flash: { "#{updated ? 'success' : 'error'}": "#{updated ? 'Success' : 'An error occured'}" })

    end

    def destroy
      folder = Folder.find(params[:folder_id])
      destroyed = folder.destroy!
      
      redirect_to has_folders ? folders_path : users_path, flash: { "#{destroyed ? 'success' : 'error'}": "#{destroyed ? 'Success' : 'An error occured'}" }
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

    def folders_params
      params.permit(:name, :current_folder_id)
    end

    def folder
      @folder = Folder.find(params[:id])
    end

    def folder_search
      'lower(name) similar to lower(:query)'
    end

    def new_folder
      @new_folder = current_team_member.folders.new
    end

    def has_folders
      current_team_member.folders.where(parent_folder: nil).length > 0
    end

    def set_breadcrumbs
      add_breadcrumb('My Profile', team_member_path(current_team_member), 'fas fa-user-edit')
      add_breadcrumb('My Folders', nil, 'fas fa-folder') unless action_name != 'index'
    end
  end
end
