# frozen_string_literal: true

if DiaryEntryPermission.count.zero?
  print "#{pretty_print_name('Diary Permissions')}\tStart: #{pretty_print(Time.current - @start_time)}"
  DiaryEntry.find_each do |diary_entry|
    TeamMember.find_each do |team_member|
      DiaryEntryPermission.create!(
        team_member: team_member,
        diary_entry: diary_entry,
        created_at: diary_entry.created_at,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
