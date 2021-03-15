module Users
  # app/controllers/users/journal_entry_permission_controller.rb
  class JournalEntryPermissionsController < PermissionsController
    skip_before_action :journal_entry_permissions_required

    # GET /journal_entries/:journal_entry_id/journal_entry_permissions/new
    def new
      render 'new'
    end

    # POST /journal_entries/:journal_entry_id/journal_entry_permissions/create
    def create
      @team_members.each do |team_member|
        next unless permissions_params["team_member_#{team_member.id}"] == '1'

        JournalEntryPermission.create!({ journal_entry_id: @model.id, team_member_id: team_member.id })
      end

      redirect_to authenticated_user_root_path, alert: 'Sharing permissions for team members successfully set'
    end

    protected

    def new_path
      new_journal_entry_journal_entry_permission_path(@model)
    end

    def model
      @model = JournalEntry.includes(:journal_entry_permissions).find(params[:journal_entry_id])
    end

    def second_to_last
      @second_to_last = current_user.journal_entries.includes(:journal_entry_permissions).second_to_last
    end
  end
end
