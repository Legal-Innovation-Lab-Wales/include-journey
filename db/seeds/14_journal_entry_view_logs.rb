if JournalEntryViewLog.count.zero?
  print "Journal View Logs\tStart: #{pretty_print(Time.now - @start_time)}"
  JournalEntry.all.each do |journal_entry, index|
    # Create View Log for every 7th journal entry
    next unless (journal_entry.id % 7).zero?

    TeamMember.all.each do |team_member|
      created_at = rand(1..100).days.ago
      view_count = rand(1..10)
      updated_at = view_count == 1 ? created_at : Faker::Time.between(from: created_at, to: DateTime.now)

      JournalEntryViewLog.create!(
        team_member: team_member,
        journal_entry: journal_entry,
        created_at: created_at,
        updated_at: updated_at,
        view_count: view_count
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
