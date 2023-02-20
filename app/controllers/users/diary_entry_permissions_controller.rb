module Users
  # app/controllers/users/diary_entry_permission_controller.rb
  class DiaryEntryPermissionsController < PermissionsController
    before_action :set_breadcrumbs
    # GET /diary_entries/:diary_entry_id/diary_entry_permissions/new
    def new
      add_breadcrumb('New Entry Permissions', nil, 'fas fa-plus-circle')
      @permissions = @last_permissions
      @default_permission = true

      render 'form'
    end

    # GET /diary_entries/:diary_entry_id/diary_entry_permissions/edit
    def edit
      add_breadcrumb('Edit Entry Permissions', nil, 'fas fa-plus-edit')
      @permissions = @current_permissions
      @default_permission = false

      render 'form'
    end

    protected

    def path
      diary_entries_path
    end

    def model
      @model = current_user.diary_entries.includes(:diary_entry_permissions).find(params[:diary_entry_id])
    end

    def second_to_last
      @second_to_last = current_user.diary_entries.includes(:diary_entry_permissions).second_to_last
    end

    def set_breadcrumbs
      add_breadcrumb('My Diary', diary_entries_path, 'fas fa-book')
    end
  end
end
