if DiaryEntryPermission.count.zero?
  print "#{pretty_print_name('Diary Permissions')}\tStart: #{pretty_print(Time.now - @start_time)}"
  DiaryEntry.all.each do |diary_entry|
    TeamMember.all.each do |team_member|
      DiaryEntryPermission.create!(
        team_member: team_member,
        diary_entry: diary_entry,
        created_at: diary_entry.created_at,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
