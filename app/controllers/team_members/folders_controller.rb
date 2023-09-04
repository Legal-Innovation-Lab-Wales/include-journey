module TeamMembers
  # app/controllers/team_members/folder_controller.rb
  class FoldersController < ApplicationController
    def index
      @top_folders = Folder.where(parent_folder: nil)
      @top_uploads = Upload.where(parent_folder: nil)
    end

    private

    def folder
      @folder = Folder.find(params[:id])
    end
  end
end
