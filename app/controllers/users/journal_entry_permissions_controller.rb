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
        next if permissions_params["team_member_#{team_member.id}"].to_i.zero?

        JournalEntryPermission.create!({ journal_entry: @model, team_member: team_member })
      end

      redirect_to pages_journal_entries_path(1), success: 'Sharing permissions for team members successfully set'
    end

    protected

    def new_path
      new_journal_entry_permission_path(@model)
    end

    def model
      @model = JournalEntry.includes(:journal_entry_permissions).find(params[:journal_entry_id])
    end

    def second_to_last
      @second_to_last = current_user.journal_entries.includes(:journal_entry_permissions).second_to_last
    end
  end
end
