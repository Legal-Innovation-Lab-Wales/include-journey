module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class FoldersController < ApplicationController
    before_action :set_user
    before_action :set_breadcrumbs
    before_action :new_folder, only: %i[index]
    before_action :folder_params, only: %i[create update]
    include Pagination

    def create
      @folder = new_folder
      @folder.name = folder_params[:name]
      @folder.user_id = params[:user_id]
      if @folder.save
        redirect_to user_folders_path(@user), flash: { notice: 'Successfully created folder!' }
      else
        redirect_to user_folders_path(@user), flash: { error: 'Folder not created. Please only use standard
                                                                characters and punctuation' }
      end
    end


    def update
      folder = Folder.find(params[:folder_id])
      updated = false
      if folder.update(name: folder_params[:name])
        updated = true
      end
      
      redirect_back(fallback_location: has_folders ? user_folders_path(@user) : user_path(@user)	,
        flash: { "#{updated ? 'success' : 'error'}": "#{updated ? 'Success' : 'An error occured'}" })

    end

    def destroy
      folder = Folder.find(params[:folder_id])
      destroyed = folder.destroy!
      
      redirect_to has_folders ? user_folders_path(@user) : user_path(@user), flash: { "#{destroyed ? 'success' : 'error'}": "#{destroyed ? 'Success' : 'An error occured'}" }
    end
    protected

    def resources
      folders = current_team_member.folders.where(parent_folder: nil, user_id: @user.id)
      uploads = Upload.joins(:upload_file).where(parent_folder_id: nil, user_id: @user.id)
      folders + uploads
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
      uploads = Upload.where(user_id: @user.id)
      folders = current_team_member.folders.where(parent_folder: nil)
      total_array = uploads + folders

      total_array.length > 0
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_breadcrumbs
      add_breadcrumb("#{@user.full_name}", user_path(@user), 'fas fa-user-edit')
      add_breadcrumb('Folders', nil, 'fas fa-folder') unless action_name != 'index'
    end
  end
end
