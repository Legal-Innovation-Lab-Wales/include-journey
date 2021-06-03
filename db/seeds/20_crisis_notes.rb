if CrisisNote.count.zero?
  print "Crisis Notes\t\tStart: #{pretty_print(Time.now - @start_time)}"
  CrisisEvent.all.each do |crisis_event|
    Config::CRISIS_NOTES_COUNT.times do |index|
      crisis_note = crisis_event.crisis_notes.create!(
        team_member_id: rand(1..TeamMember.count),
        content: Faker::Movies::HarryPotter.quote
      )

      next unless index.even?

      new_crisis_note = crisis_event.crisis_notes.create!(
        team_member_id: crisis_note.team_member_id,
        content: Faker::Movies::HarryPotter.quote,
        replacing: crisis_note
      )

      crisis_note.update!(replaced_by: new_crisis_note)
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
