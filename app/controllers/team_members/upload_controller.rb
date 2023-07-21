module TeamMembers
  # app/controllers/team_members/upload_controller.rb
  class UploadController < ApplicationController
    def index
      @uploads = Upload.where(user: user)
    end

    def new
      @upload = Upload.new
      @photo = Photo.new
    end

    def create
      @upload = Upload.new(
        comment: upload_params[comment],
        user: user
      )
      @upload.uploadable = current_team_member
      @photo = new_photo

      if @upload.save! && @photo.save!
        flash[:success] = 'Upload added successfully!'
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def edit
      @photo = @upload.photos.first_or_initialize
    end

    def update
      @photo = @upload.photos.first_or_initialize
      @upload.update(comment: upload_params[comment])
      @photo.data = upload_params[:image_file].read if upload_params[:image_file]

      if @photo.save! && @upload.save!
        redirect_to upload_path(@upload)
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    private

    def upload_params
      params.require(:upload).permit(:comments, :image_file, :cached_image)
    end

    def user
      User.find(params[:user_id])
    end

    def upload
      @upload = Upload.find(params[:id])
    end

    def encode(insert_file)
      Base64.decode64(insert_file)
    end

    def new_photo
      photo = Photo.new
      photo.data = if upload_params[:cached_image]
                     encode(upload_params[:cached_image])
                   elsif upload_params[:image_file]
                     upload_params[:image_file].read
                   end
      photo.upload = @upload
      photo
    end
  end
end
