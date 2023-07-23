module Users
  # app/controllers/users/upload_controller.rb
  class UploadsController < ApplicationController
    before_action :set_breadcrumbs

    def index
      @uploads = Upload.where(user: current_user)
    end

    def new
      add_breadcrumb('New Upload', nil, 'fas fa-plus-circle')
      @upload = Upload.new
      @upload_file = UploadFile.new
    end

    def create
      @upload = Upload.new(
        comment: upload_params[comment],
        user: current_user
      )
      @upload.uploadable = current_user
      @upload_file = new_upload_file

      if @upload.save! && @upload_file.save!
        flash[:success] = 'Upload added successfully!'
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @upload_file = @upload.upload_files.first_or_initialize
    end

    def update
      @upload_file = @upload.upload_files.first_or_initialize
      @upload.update(comment: upload_params[comment])
      @upload_file.data = upload_params[:image_file].read if upload_params[:image_file]

      if @upload_file.save! && @upload.save!
        redirect_to upload_path(@upload)
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    private

    def upload_params
      params.require(:upload).permit(:comments, :image_file, :cached_image)
    end

    def upload
      @upload = Upload.find(params[:id])
    end

    def encode(insert_file)
      Base64.decode64(insert_file)
    end

    def new_upload_file
      upload_file = UploadFile.new
      upload_file.data = if upload_params[:cached_image]
                     encode(upload_params[:cached_image])
                   elsif upload_params[:image_file]
                     upload_params[:image_file].read
                   end
      upload_file.upload = @upload
      upload_file
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : uploads_path
      add_breadcrumb('My Uploads', path, 'fas fa-upload')
    end
  end
end
