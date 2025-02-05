# frozen_string_literal: true

if ContactLog.count.zero?
  print "#{pretty_print_name('Contact Logs')}\tStart: #{pretty_print(Time.current - @start_time)}"
  TeamMember.find_each do |team_member|
    Config::CONTACT_LOGS_FOR_EACH_TEAM_MEMBER.times do
      app_time = Faker::Time.between(from: Time.current, to: DateTime.yesterday - 60.days)
      note = Faker::Quotes::Shakespeare.hamlet_quote.gsub! ';', ':'
      ContactLog.create!(
        team_member: team_member,
        user: User.where(id: rand(1..User.all.size)).first,
        contact_type: ContactType.where(id: rand(1..ContactType.all.size)).first,
        contact_purpose: ContactPurpose.where(id: rand(1..ContactPurpose.all.size)).first,
        notes: note,
        start: app_time,
        end: app_time + rand(10..120).minutes,
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
