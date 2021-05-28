if JournalEntryPermission.count.zero?
  print "Journal Permissions\tStart: #{Time.now - @start_time}"
  JournalEntry.all.each do |journal_entry|
    TeamMember.all.each do |team_member|
      JournalEntryPermission.create!(
        team_member: team_member,
        journal_entry: journal_entry,
        created_at: journal_entry.created_at
      )
    end
  end

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
