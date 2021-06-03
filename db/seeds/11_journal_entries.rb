if JournalEntry.count.zero?
  print "Journal Entries\t\tStart: #{Time.now - @start_time}"
  User.all.each do |user|
    Config::JOURNAL_ENTRIES_FOR_EACH_USER.times do
      JournalEntry.create!(
        user: user,
        entry: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
        feeling: %w[🥳 😊 😔 😠 💩 😐].sample,
        created_at: Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now)
      )
    end
  end

  puts "\tDuration: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
