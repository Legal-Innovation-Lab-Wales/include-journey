# app/helpers/journal_entries_helper.rb
module JournalEntriesHelper
  def viewed(journal_entry_view_logs, journal_entry_id)
    return false unless journal_entry_view_logs.present?

    journal_entry_view_logs.find { |view_log| view_log[:id] == journal_entry_id }.present?
  end
end
