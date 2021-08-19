# if JournalEntry.count.zero?
#   print "#{pretty_print_name('Journal Entries')}\tStart: #{pretty_print(Time.now - @start_time)}"
#   User.all.each do |user|
#     Config::JOURNAL_ENTRIES_FOR_EACH_USER.times do
#       JournalEntry.create!(
#         user: user,
#         entry: Faker::Movies::HitchhikersGuideToTheGalaxy.quote,
#         feeling: %w[🥳 😊 😔 😠 💩 😐].sample,
#         created_at: Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now)
#       )
#     end
#   end
#
#   puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
#   @last_time = Time.now
# end
