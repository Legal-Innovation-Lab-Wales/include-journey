# frozen_string_literal: true

module Users
  # app/controllers/users/journal_entry_permission_controller.rb
  class JournalEntryPermissionsController < UsersApplicationController
    skip_before_action :journal_entry_permissions_required
    before_action :journal_entry, :verify_user, :verify_permissions_needed, :team_members
    before_action :second_to_last_journal_entry, only: :new
    before_action :last_journal_entry_permissions, only: :new, if: -> { @second_to_last_journal_entry.present? }
    before_action :journal_entry_permissions_params, :validate_permissions_params, :create_journal_entry_permissions, only: :create

    # GET /journal_entries/:journal_entry_id/journal_entry_permissions/new
    def new
      render 'new'
    end

    # POST /journal_entries/:journal_entry_id/journal_entry_permissions/create
    def create
      respond_to do |format|
        format.html { redirect_to authenticated_user_root_path, alert: 'Sharing permissions for team members successfully set' }
      end
    end

    private

    def last_journal_entry_permission(team_member_id)
      return true unless @second_to_last_journal_entry.present?

      @last_journal_entry_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    helper_method :last_journal_entry_permission

    def create_journal_entry_permissions
      @team_members.each do |team_member|
        next unless journal_entry_permissions_params["team_member_#{team_member.id}"] == '1'

        JournalEntryPermission.create!({ journal_entry_id: @journal_entry.id, team_member_id: team_member.id })
      end
    end

    def journal_entry
      @journal_entry = JournalEntry.find(params[:journal_entry_id])
    end

    def last_journal_entry_permissions
      @last_journal_entry_permissions = @second_to_last_journal_entry.journal_entry_permissions.collect { |journal_entry_permission| { id: journal_entry_permission.team_member_id }}
    end

    def second_to_last_journal_entry
      @second_to_last_journal_entry = current_user.journal_entries.includes(:journal_entry_permissions).second_to_last
    end

    def journal_entry_permissions_params
      params.require(:journal_entry).permit(@team_members.map { |team_member| "team_member_#{team_member.id}" })
    end

    def team_members
      @team_members = TeamMember.all
    end

    def validate_permissions_params
      return if @team_members.map { |team_member| journal_entry_permissions_params["team_member_#{team_member.id}"] }.include? '1'

      redirect_to new_journal_entry_journal_entry_permission_path(@journal_entry), alert: 'You must select at least one team member!'
    end

    def verify_user
      return if @journal_entry.user == current_user

      redirect_to authenticated_user_root_path, alert: 'That journal entry does not belong to you'
    end

    def verify_permissions_needed
      return unless @journal_entry.journal_entry_permissions.present?

      # redirect_to journal_entry_path(@journal_entry), alert: 'Permissions have already been set for that wellbeing assessment'
      redirect_to authenticated_user_root_path, alert: 'Permissions have already been set for that journal entry'
    end
  end
end
