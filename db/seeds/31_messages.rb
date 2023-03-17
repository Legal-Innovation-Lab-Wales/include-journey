if Message.count.zero?
  print "#{pretty_print_name('Message')}\tStart: #{pretty_print(Time.now - @start_time)}"

  Note.where(visible_to_user: true, replacing: nil).each do |note|
    message = Message.new(team_member_id: note.team_member.id,
                          user_id: note.user.id,
                          read: [true, false].sample,
                          message_status: %w[created updated].sample,
                          note_id: note.id)
    message.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
