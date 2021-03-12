# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    before_action :wba_self_permissions_required, :journal_entry_permissions_required, :permissions_required, :last_wba_self, only: :main
    before_action :wba_self_today, :wellbeing_metrics, only: :main, unless: -> { @wba_self_permissions_required }
    before_action :journal_entry, :journal_entries, only: :main, unless: -> { @journal_entry_permissions_required }

    before_action :last_scores, only: :main, if: -> { @last_wba_self.present? }
    before_action :wba_self, only: :main, unless: -> { @wba_self_today }

    before_action :second_to_last_wba_self, only: :main, if: -> { @wba_self_permissions_required }
    before_action :last_wba_self_permissions, only: :main, if: -> { @second_to_last_wba_self.present? }

    before_action :last_journal_entry, :second_to_last_journal_entry, only: :main, if: -> { @journal_entry_permissions_required }
    before_action :last_journal_entry_permissions, only: :main, if: -> { @second_to_last_journal_entry.present? }

    before_action :team_members, only: :main, if: -> { @permissions_required }

    def main
      render template: 'users/dashboard/main'
    end

    def last_score(wellbeing_metric_id)
      return 6 unless @last_scores.present?

      @last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
    end

    def last_wba_self_permission(team_member_id)
      return true unless @second_to_last_wba_self.present?

      @last_wba_self_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    def last_journal_entry_permission(team_member_id)
      return true unless @second_to_last_journal_entry.present?

      @last_journal_entry_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    helper_method :last_score, :last_wba_self_permission, :last_journal_entry_permission

    private

    def wba_self
      @wba_self = WbaSelf.new
    end

    def wba_self_today
      @wba_self_today = current_user.wba_selves.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present?
    end

    def journal_entry
      @journal_entry = JournalEntry.new
    end

    def journal_entries
      @journal_entries = current_user.journal_entries.order(created_at: :desc)
    end

    def last_scores
      @last_scores = @last_wba_self.wba_self_scores.collect { |wba_self_score| { id: wba_self_score.wellbeing_metric_id, value: wba_self_score.value }}
    end

    def last_wba_self_permissions
      @last_wba_self_permissions = @second_to_last_wba_self.wba_self_permissions.collect { |wba_self_permission| { id: wba_self_permission.team_member_id }}
    end

    def last_wba_self
      @last_wba_self = current_user.wba_selves.includes(:wba_self_scores).last
    end

    def last_journal_entry
      @last_journal_entry = current_user.journal_entries.last
    end

    def last_journal_entry_permissions
      @last_journal_entry_permissions = @second_to_last_journal_entry.journal_entry_permissions.collect { |journal_entry_permission| { id: journal_entry_permission.team_member_id }}
    end

    def second_to_last_wba_self
      @second_to_last_wba_self = current_user.wba_selves.includes(:wba_self_permissions).second_to_last
    end

    def second_to_last_journal_entry
      @second_to_last_journal_entry = current_user.journal_entries.includes(:journal_entry_permissions).second_to_last
    end

    def journal_entry_permissions_required
      @journal_entry_permissions_required = current_user.journal_entry_permissions_required?
    end

    def wba_self_permissions_required
      @wba_self_permissions_required = current_user.wba_self_permissions_required?
    end

    def permissions_required
      @permissions_required = @wba_self_permissions_required || @journal_entry_permissions_required
    end

    def team_members
      @team_members = TeamMember.all
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
