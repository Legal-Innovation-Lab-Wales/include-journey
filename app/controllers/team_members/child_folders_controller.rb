module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class ChildFoldersController < ApplicationController
    before_action :set_user
    before_action :current_parent_folder, except: %i[destroy]
    before_action :set_breadcrumbs
    before_action :new_child_folder, only: %i[index]
    before_action :child_folder_params, only: %i[create update]
    include Pagination

    def create
      @child_folder = new_child_folder
      @child_folder.name = child_folder_params[:name]
      @child_folder.parent_folder_id = child_folders_params[:folder_id]
      @child_folder.user_id = current_parent_folder.user_id
      if @child_folder.save
        redirect_to user_folder_children_path(@user, current_parent_folder), flash: { notice: 'Successfully created folder!' }
      else
        redirect_to user_folder_children_path(@user, current_parent_folder), flash: { error: 'Folder not created. Please only use standard
                                                                characters and punctuation' }
      end
    end

    def destroy
      folder = Folder.find(params[:folder_id])
      parent = folder.parent_folder
    
      destroyed = folder.destroy!

      has_siblings = parent && parent.child_folders.length > 0 && Upload.where(user_id: @user.id, parent_folder_id: parent.id)
      path = has_siblings ? user_folder_children_path(@user, parent) : has_folders(parent) ? user_folders_path(@user) : user_path(@user)

      redirect_to path, flash: { "#{destroyed ? 'success' : 'error'}": "#{destroyed ? 'Success' : 'An error occured'}" }
    end

    protected

    def resources
      folders = Folder.where(parent_folder_id: @current_parent_folder.id)
      uploads = Upload.joins(:upload_file).where(parent_folder_id: @current_parent_folder.id)
      folders + uploads
    end

    def resources_per_page
      12
    end

    def search
      resource_ids = resources.map(&:id)

      folder_results = Folder.where(id: resource_ids).where(child_folder_search, wildcard_query)
      
      upload_results = Upload.joins(:upload_file)
                            .where(id: resource_ids)
                            .where(child_folder_search, wildcard_query)
    
      folder_results + upload_results
    end


    def has_folders(parent)
      uploads = Upload.where(user_id: @user.id, parent_folder_id: parent.id)
      folders = current_team_member.folders.where(parent_folder_id: parent.id, user_id: @user.id)
      total_array = uploads + folders
    
      total_array.length > 0
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


    def child_folder_search
      'lower(name) similar to lower(:query)'
    end

    def new_child_folder
      @new_child_folder = current_team_member.folders.new
    end
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_breadcrumbs
      add_breadcrumb("#{@user.full_name}", user_path(@user), 'fas fa-user-edit')
      add_breadcrumb('Folders', user_folders_path(@user), 'fas fa-folder') unless action_name != 'index'
      store_folder_tree.each do |folder|
        if !folder
          return
        elsif folder == store_folder_tree[-1]
          add_breadcrumb(folder.name, nil, 'fas fa-folder')
        else
          add_breadcrumb(folder.name, user_folder_children_path(@user, folder), 'fas fa-folder')
        end
      end
    end

    def find_folder(id)
      Folder.find(id)
    end

    def store_folder_tree
      folder_arr = [@current_parent_folder]
      child_folder = @current_parent_folder
      until !child_folder || child_folder.parent_folder_id.nil?
        parent_folder = find_folder(child_folder.parent_folder_id)
        folder_arr.unshift(parent_folder)
        child_folder = parent_folder
      end

      folder_arr
    end
  end

end
