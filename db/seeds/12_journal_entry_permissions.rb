if JournalEntryPermission.count.zero?
  JournalEntry.all.each do |journal_entry|
    TeamMember.all.each do |team_member|
      JournalEntryPermission.create!(
        team_member: team_member,
        journal_entry: journal_entry,
        created_at: journal_entry.created_at
      )
    end
  end

  puts "Journal Permissions\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
