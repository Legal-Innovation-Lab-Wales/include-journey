# frozen_string_literal: true

if Note.none?
  print "#{pretty_print_name('Notes')}\tStart: #{pretty_print(Time.current - @start_time)}"
  Config::NOTES_COUNT.times do |index|
    note = Note.create!(
      team_member_id: rand(1..TeamMember.count),
      visible_to_user: [true, false].sample,
      user_id: rand(1..User.count),
      content: Faker::TvShows::TheExpanse.quote,
      dated: Faker::Time.between(from: 2.years.ago, to: Time.current),
    )

    # Every fifth note is replaced by a new note to demonstrate the edit history functionality
    next unless (index % 5).zero?

    new_note = Note.create!(
      team_member_id: note.team_member.id,
      visible_to_user: [true, false].sample,
      user_id: note.user.id,
      content: Faker::TvShows::TheExpanse.quote,
      replacing: note,
      dated: Faker::Time.between(from: 2.years.ago, to: Time.current),
    )

    note.update!(replaced_by: new_note)
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
