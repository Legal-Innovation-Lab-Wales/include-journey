module TeamMembers
  # app/controllers/team_members/upload_controller.rb
  class UploadsController < ApplicationController
    before_action :set_breadcrumbs
    before_action :user
    before_action :upload, only: %i[show update destroy download_file approve]
    include Pagination
    include UploadsHelper

    def new
      if session.key?(:custom_view)
        add_breadcrumb('Uploads', user_uploads_path(user_id: user.id, view: :list), 'fas fa-upload')
      else
        add_breadcrumb('Uploads', user_uploads_path(user_id: user.id), 'fas fa-upload')
      end
      add_breadcrumb('New Upload', nil, 'fas fa-plus-circle')
      @upload = @user.uploads.new
      @upload_file = UploadFile.new
    end

    def create
      @upload = Upload.new(comment: upload_params[:comment],
                           visible_to_user: upload_params[:visible_to_user],
                           user: @user,
                           added_by: 'TeamMember',
                           added_by_id: current_team_member.id,
                           status: 'approved')

      @upload_file = new_upload_file
      @upload_file.upload = @upload

      max_file_size = 250.megabytes
      if @upload_file.data.size > max_file_size
        flash[:error] = 'File size exceeds the maximum limit of 250MB.'
        render 'new', status: :unprocessable_entity
        return
      end

      if @upload.save && @upload_file.save
        flash[:success] = 'Upload added successfully!'
        redirect_to correct_uploads_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def show
      log_uploads_activity('viewed')
      @upload_file = @upload.upload_file
      icon = @upload_file.content_type == 'application/pdf' ? 'fas fa-file-pdf' : 'fas fa-image'
      add_breadcrumb('Uploads', user_uploads_path(user_id: user.id, view: :list), 'fas fa-upload') if session.key?(:custom_view)
      add_breadcrumb('Uploads', user_uploads_path(user_id: user.id), 'fas fa-upload') unless session.key?(:custom_view)
      add_breadcrumb(@upload_file.name.to_s, nil, icon)
    end

    def update
      @upload_file = @upload.upload_file
      @upload.update(comment: upload_params[:comment])
      @upload_file.update(name: upload_params[:name])

      if @upload_file.save && @upload.save
        log_uploads_activity('modified')
        redirect_to user_upload_path(@user, @upload)
        flash[:success] = 'Upload updated successfully!'
      else
        flash.now[:error] = 'Please use alphanumeric characters only.'
        render 'show', status: :unprocessable_entity
      end
    end

    def download_file
      @upload_file = @upload.upload_file
      pdf_blob = @upload_file.data
      log_uploads_activity('downloaded') if @upload.added_by == 'User'

      case @upload_file.content_type
      when 'application/pdf'
        send_data pdf_blob, filename: @upload_file.name, type: 'application/pdf', disposition: 'attachment'
      when 'image/jpeg'
        send_data pdf_blob, filename: @upload_file.name, type: 'image/jpeg', disposition: 'attachment'
      when 'image/png'
        send_data pdf_blob, filename: @upload_file.name, type: 'image/png', disposition: 'attachment'
      end
    end

    def approve
      return if @upload.status == 'approved'

      if @upload.update(status: 'approved',
                        approved_at: Time.now,
                        approved_by: current_team_member.full_name)
        flash[:success] = 'Upload has been successfully approved.'
        log_uploads_activity('approved')
      else
        flash[:error] = 'Failed to approve the upload.'
      end
      redirect_back(fallback_location: root_path)
    end

    def destroy
      action = params[:reject] == 'true' ? 'rejected' : 'deleted'
      log_uploads_activity(action) if action == 'rejected'

      if @upload.destroy
        flash[:notice] = "Upload was #{action} successfully!"
        redirect_to user_uploads_path
      else
        flash[:error] = 'Failed to delete the upload, please try again!'
        redirect_to @upload
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
      @uploads = @user.uploads.joins(:upload_file).order(created_at: :desc)

      filter_params = uploads_filter_params

      @uploads = @uploads.where(added_by: filter_params[:added]) if filter_params[:added].in?(['User', 'TeamMember'])
      @uploads = @uploads.where(added_by_id: current_team_member.id) if filter_params[:added] == 'You'
      @uploads = @uploads.where(upload_files: { content_type: 'application/pdf' }) if filter_params[:type] == 'PDF'
      @uploads = @uploads.where(upload_files: { content_type: ['image/jpeg', 'image/png'] }) if filter_params[:type] == 'Images'
      @uploads = @uploads.where(visible_to_user: true) if filter_params[:visible] == 'visible'
      @uploads = @uploads.where(visible_to_user: false) if filter_params[:visible] == 'invisible'

      @uploads
    end

    def resources_per_page
      12
    end

    def search
      resources.where(upload_search, wildcard_query)
    end

    private

    def upload_params
      params.require(:upload).permit(:comment, :file, :cached_file, :content_type, :name, :visible_to_user)
    end

    def uploads_filter_params
      params.permit(:query, :added, :type, :visible, :user_id, :page, :id)
    end

    def user
      @user = User.includes(:uploads).find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:user_id]))
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

    def upload_search
      'lower(upload_files.name) similar to lower(:query)'
    end

    def log_uploads_activity(activity_type)
      upload_activity_log = current_team_member.upload_activity_logs.find_or_initialize_by(upload_id: uploads_filter_params[:id],
                                                                                           activity_type: activity_type)

      if upload_activity_log.new_record?
        upload_activity_log.activity_type = activity_type
        upload_activity_log.activity_time = Time.now
      end

      upload_activity_log.activity_count += 1
      upload_activity_log.save!
    end

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(user.full_name, user_path(user))

      add_breadcrumb('Uploads', nil, 'fas fa-upload') unless action_name != 'index'
    end
  end
end
