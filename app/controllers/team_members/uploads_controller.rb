module TeamMembers
  # app/controllers/team_members/upload_controller.rb
  class UploadsController < ApplicationController
    before_action :set_breadcrumbs
    before_action :user
    before_action :upload, only: %i[new create edit update destroy download_file]
    include Pagination

    def new
      add_breadcrumb('New Upload', nil, 'fas fa-plus-circle')
      @upload = @user.uploads.new
      @upload_file = UploadFile.new
    end

    def create
      @upload = Upload.new(comment: upload_params[:comment],
                           user: @user)
      @upload.uploadable = current_team_member

      @upload_file = new_upload_file
      @upload_file.upload = @upload

      if @upload.save! && @upload_file.save!
        flash[:success] = 'Upload added successfully!'
        redirect_back(fallback_location: root_path)
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
      else
        flash[:alert] = 'Something went wrong!'
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
      Upload.where(uploadable_type: 'TeamMember').or(Upload.where(uploadable_type: 'User'))
            .joins(:upload_file)
    end

    def resources_per_page
      9
    end

    def search
      Upload.where(uploadable_type: 'TeamMember').or(Upload.where(uploadable_type: 'User'))
            .where(user_id: @user.id).joins(:upload_file)
            .where(upload_search, wildcard_query).order(created_at: :desc)
    end

    private

    def upload_params
      params.require(:upload).permit(:comment, :file, :cached_file, :content_type, :name)
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

    def set_breadcrumbs
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(user.full_name, user_path(user))

      add_breadcrumb('Uploads') unless action_name != 'index'
    end
  end
end
