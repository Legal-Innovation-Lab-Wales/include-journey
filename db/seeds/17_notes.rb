if Note.count.zero?
  print "Notes\t\t\tStart: #{Time.now - @start_time}"
  Config::NOTES_COUNT.times do |index|
    note = Note.create!(
      team_member_id: rand(1..TeamMember.count),
      visible_to_user: [true, false].sample,
      user_id: rand(1..User.count),
      content: Faker::TvShows::TheExpanse.quote
    )

    # Every fifth note is replaced by a new note to demonstrate the edit history functionality
    next unless (index % 5).zero?

    new_note = Note.create!(
      team_member_id: note.team_member.id,
      visible_to_user: [true, false].sample,
      user_id: note.user.id,
      content: Faker::TvShows::TheExpanse.quote,
      replacing: note
    )

    note.update!(replaced_by: new_note)
  end

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
