module Users
  # app/controllers/users/upload_controller.rb
  class UploadsController < ApplicationController
    before_action :set_breadcrumbs
    before_action :upload, only: %i[update show destroy download_file]
    include Pagination

    def new
      add_breadcrumb('New Upload', nil, 'fas fa-plus-circle')
      @upload = Upload.new
      @upload_file = UploadFile.new
    end

    def create
      @upload = Upload.new(comment: upload_params[:comment], visible_to_user: true,
                           user: current_user, added_by: 'User', added_by_id: current_user.id)
      @upload_file = new_upload_file
      @upload_file.upload = @upload

      max_file_size = 250.megabytes
      if @upload_file.data.size > max_file_size
        flash[:error] = 'File size exceeds the maximum limit of 250MB.'
        render 'new', status: :unprocessable_entity
        return
      end

      if @upload.save! && @upload_file.save!
        email_team_members_about_upload(current_user, @upload_file)
        flash[:success] = 'Upload added successfully!'
        redirect_to uploads_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def show
      @upload_file = @upload.upload_file
      icon = @upload_file.content_type == 'application/pdf' ? 'fas fa-file-pdf' : 'fas fa-image'
      add_breadcrumb(@upload_file.name.to_s, nil, icon)
    end

    def update
      if @upload.status == 'approved'
        flash[:success] = 'You cannot update an approved upload.'
        redirect_to upload_path(@upload)
      else
        @upload_file = @upload.upload_file
        @upload.update(comment: upload_params[:comment])
        @upload_file.update(name: upload_params[:name])

        if @upload_file.save && @upload.save
          flash[:success] = 'Upload updated successfully!'
          redirect_to upload_path(@upload)
        else
          flash[:error] = 'Please use alphanumeric characters only.'
          render 'show', status: :unprocessable_entity
        end
      end
    end

    def destroy
      @upload.destroy
      redirect_to uploads_path, notice: 'Upload was successfully deleted.'
    end

    def download_file
      @upload_file = @upload.upload_file
      pdf_blob = @upload_file.data

      case @upload_file.content_type
      when 'application/pdf'
        send_data pdf_blob, filename: @upload_file.name, type: 'application/pdf', disposition: 'attachment'
      when 'image/jpeg'
        send_data pdf_blob, filename: @upload_file.name, type: 'image/jpeg', disposition: 'attachment'
      when 'image/png'
        send_data pdf_blob, filename: @upload_file.name, type: 'image/png', disposition: 'attachment'
      end
    end

    def subheading_stats
      return unless @resources.present?

      @uploads_in_last_30_days = @resources.created_in_last_month.count
      @image_uploads = @resources.images.count
      @pdf_uploads = @resources.pdf_files.count
      @team_member_uploads = @resources.uploaded_by_teammember.count
      @user_uploads = @resources.uploaded_by_user.count
    end

    protected

    def resources
      current_user.uploads.where(visible_to_user: true).joins(:upload_file).order(created_at: :desc)
    end

    def resources_per_page
      12
    end

    def search
      resources.where('lower(upload_files.name) similar to lower(:query)', wildcard_query)
    end

    private

    def upload_params
      params.require(:upload).permit(:comment, :file, :cached_file, :content_type, :name)
    end

    def upload
      @upload = Upload.find(params[:id])
    end

    def encode(insert_file)
      Base64.decode64(insert_file)
    end

    def new_upload_file
      UploadFile.new(name: upload_params[:name],
                     content_type: upload_params[:file].content_type,
                     data: if upload_params[:cached_file]
                             encode(upload_params[:cached_file])
                           elsif upload_params[:file]
                             upload_params[:file].read
                           end)
    end

    def email_team_members_about_upload(user, upload_file)
      team_members = user.team_members
      return unless team_members.present?

      upload_type = upload_file.content_type == 'application/pdf' ? 'PDF' : 'image'
      UploadsMailer.new_user_upload(team_members, user, upload_type).deliver_now
    end

    def set_breadcrumbs
      path = if session.key?(:custom_view)
               action_name == 'index' ? nil : uploads_path(view: :list)
             else
               action_name == 'index' ? nil : uploads_path
             end
      add_breadcrumb('My Uploads', path, 'fas fa-upload')
    end
  end
end
