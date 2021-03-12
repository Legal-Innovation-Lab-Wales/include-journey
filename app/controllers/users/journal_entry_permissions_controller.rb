# frozen_string_literal: true

module Users
  # app/controllers/users/journal_entry_permission_controller.rb
  class JournalEntryPermissionsController < UsersApplicationController
    before_action :journal_entry, :team_members, :journal_entry_permissions_params, :validate_permissions_params, :create_journal_entry_permissions, only: :create

    # POST /journal_entries/:journal_entry_id/journal_entry_permissions/create
    def create
      respond_to do |format|
        format.html { redirect_to authenticated_user_root_path, alert: journal_entry_permissions_alert }
      end
    end

    private

    def create_journal_entry_permissions
      @team_members.each do |team_member|
        next unless journal_entry_permissions_params[team_member_id(team_member)] == '1'

        JournalEntryPermission.create!({ journal_entry_id: @journal_entry.id, team_member_id: team_member.id })
      end
    end

    def team_members
      @team_members = TeamMember.all
    end

    def team_member_id(team_member)
      "team_member_#{team_member.id}".to_sym
    end

    def journal_entry
      @journal_entry = JournalEntry.find(params[:journal_entry_id])
    end

    def journal_entry_permissions_alert
      'Sharing permissions for team members successfully set'
    end

    def journal_entry_permissions_params
      params.require(:journal_entry).permit(@team_members.map { |team_member| team_member_id(team_member) })
    end

    def validate_permissions_params
      if @team_members.map { |team_member| journal_entry_permissions_params[team_member_id(team_member)] }.include? '1'
        return
      end

      redirect_to authenticated_user_root_path, alert: 'You must select at least one team member!'
    end
  end
end
