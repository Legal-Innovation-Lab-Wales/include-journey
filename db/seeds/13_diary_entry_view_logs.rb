# frozen_string_literal: true

if DiaryEntryViewLog.count.zero?
  print "#{pretty_print_name('Diary View Logs')}\tStart: #{pretty_print(Time.current - @start_time)}"
  DiaryEntry.find_each do |diary_entry|
    # Create View Log for every 7th diary entry
    next unless (diary_entry.id % 7).zero?

    TeamMember.find_each do |team_member|
      created_at = rand(1..100).days.ago
      view_count = rand(1..10)
      updated_at = view_count == 1 ? created_at : Faker::Time.between(from: created_at, to: Time.current)

      DiaryEntryViewLog.create!(
        team_member: team_member,
        diary_entry: diary_entry,
        created_at: created_at,
        updated_at: updated_at,
        view_count: view_count,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
