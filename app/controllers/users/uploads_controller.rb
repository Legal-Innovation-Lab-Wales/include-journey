module Users
  # app/controllers/users/upload_controller.rb
  class UploadsController < ApplicationController
    include Pagination
    include UploadsHelper
    include NotificationsHelper

    before_action :set_breadcrumbs
    before_action :upload, only: %i[update show destroy download_file]
    after_action :update_user_upload_notification_to_viewed, only: :show

    def new
      add_breadcrumb('Upload File', nil, 'fas fa-upload')
      @upload = Upload.new
      @upload_file = UploadFile.new
    end

    def create
      @upload = new_upload
      @upload_file = new_upload_file
      @upload_file.upload = @upload

      if check_file_size == 'exceeds individual file size'
        flash[:error] = "File size exceeds the maximum limit of #{eval(ENV['MAX_FILE_SIZE'])}"
        render 'new', status: :unprocessable_entity
      elsif check_file_size == 'exceeds total file size per person'
        flash[:error] = "Your overall file usage has gone beyond the allocated limit of #{eval(ENV['TOTAL_MAX_FILE_SIZE'])} per person.
                         It\'s recommended to create space by removing older files."
        render 'new', status: :unprocessable_entity
      elsif @upload.save && @upload_file.save
        email_team_members_about_upload(current_user, @upload_file)
        current_user.increment!(:total_upload_size, @upload_file.data.size)
        handle_successful_upload_creation
      else
        handle_failed_upload_creation
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
          flash[:success] = 'File updated successfully!'
          redirect_to upload_path(@upload)
        else
          flash[:error] = 'Please use alphanumeric characters only.'
          render 'show', status: :unprocessable_entity
        end
      end
    end

    def destroy
      if @upload.destroy
        current_user.decrement!(:total_upload_size, @upload.upload_file.data.size)
        if Upload.where(user: current_user).count.zero?
          flash[:error] = 'You have no files to see.'
          redirect_to new_upload_path
        else
          redirect_to uploads_path, notice: 'File was successfully deleted.'
        end
      else
        redirect_to @upload, alert: 'Something went wrong, file could not be deleted!'
      end
    end

    def download_file
      @upload_file = @upload.upload_file
      file_blob = @upload_file.data

      case @upload_file.content_type
      when 'application/pdf'
        send_data file_blob, filename: @upload_file.name, type: 'application/pdf', disposition: 'attachment'
      when 'image/jpeg'
        send_data file_blob, filename: @upload_file.name, type: 'image/jpeg', disposition: 'attachment'
      when 'image/png'
        send_data file_blob, filename: @upload_file.name, type: 'image/png', disposition: 'attachment'
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
      params.require(:upload).permit(:comment, :file, :cached_file, :content_type, :name, :visible_to_user)
    end

    def upload
      @upload = Upload.find(params[:id])
    end

    def encode(insert_file)
      Base64.decode64(insert_file)
    end

    def new_upload
      Upload.new(
        comment: upload_params[:comment],
        visible_to_user: true,
        user: current_user,
        added_by: 'User',
        added_by_id: current_user.id
      )
    end

    def new_upload_file_resources
      {
        content_type: upload_params[:file].respond_to?(:content_type) ? upload_params[:file].content_type : nil,
        data: if upload_params[:cached_file]
                encode(upload_params[:cached_file])
              elsif upload_params[:file]
                upload_params[:file].read
              end
      }
    end

    def new_upload_file
      UploadFile.new(
        name: upload_params[:name],
        content_type: new_upload_file_resources[:content_type],
        data: new_upload_file_resources[:data]
      )
    end

    def email_team_members_about_upload(user, upload_file)
      team_members = user.team_members
      return unless team_members.present?

      upload_type = upload_file.content_type == 'application/pdf' ? 'PDF' : 'image'
      UploadsMailer.new_user_upload(team_members, user, upload_type).deliver_now
    end

    def handle_successful_upload_creation
      flash[:success] = 'File added successfully!'
      redirect_to correct_uploads_path
    end

    def handle_failed_upload_creation
      flash[:error] = 'Something went wrong! Please check the error message below or try uploading the file again'
      render 'new', status: :unprocessable_entity
    end

    def check_file_size
      max_file_size = eval(ENV['MAX_FILE_SIZE'])
      total_max_file_size = eval(ENV['TOTAL_MAX_FILE_SIZE'])
      if @upload_file.data.size > max_file_size
        'exceeds individual file size'
      elsif current_user.total_upload_size + @upload_file.data.size >= total_max_file_size
        'exceeds total file size per person'
      else
        'pass check'
      end
    end

    def update_user_upload_notification_to_viewed
      user_upload_notification = current_user.uploads.find(@upload.id).notification
      return unless user_upload_notification && user_upload_notification.viewed == false

      user_upload_notification.update!(viewed: true)
    end

    def set_breadcrumbs
      path = if session.key?(:custom_view)
               action_name == 'index' ? nil : uploads_path(view: :list)
             else
               action_name == 'index' ? nil : uploads_path
             end
      add_breadcrumb('My Files', path, 'fas fa-file')
    end
  end
end
