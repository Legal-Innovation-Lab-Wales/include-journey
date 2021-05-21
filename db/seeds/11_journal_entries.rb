if JournalEntry.count.zero?
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

  puts "Journal Entries\t\tTime: #{Time.now - @last_time}\tElapsed: #{Time.now - @start_time}"
  @last_time = Time.now
end
