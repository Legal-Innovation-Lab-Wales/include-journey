# frozen_string_literal: true

if DiaryEntry.none?
  print "#{pretty_print_name('Diary Entries')}\tStart: #{pretty_print(Time.current - @start_time)}"
  User.find_each do |user|
    Config::DIARY_ENTRIES_FOR_EACH_USER.times do
      DiaryEntry.create!(
        user: user,
        entry: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
        feeling: ['🥳', '😊', '😔', '😠', '💩', '😐'].sample,
        created_at: Faker::Time.between(from: 1.year.ago, to: Time.current),
      )
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
