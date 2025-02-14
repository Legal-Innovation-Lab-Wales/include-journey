# frozen_string_literal: true

if Affirmation.none?
  print "#{pretty_print_name('Affirmations')}\tStart: #{pretty_print(Time.current - @start_time)}"
  Config::UPCOMING_AFFIRMATIONS.times.each do |index|
    text = if index < (Config::UPCOMING_AFFIRMATIONS / 3)
      Faker::Quotes::Shakespeare.hamlet_quote
    elsif index < ((Config::UPCOMING_AFFIRMATIONS / 3) * 2)
      Faker::Quotes::Shakespeare.romeo_and_juliet_quote
    else
      Faker::Quotes::Shakespeare.king_richard_iii_quote
    end
    text.gsub! ';', ':'
    Affirmation.create!(
      text: text,
      scheduled_date: Date.current + index.days,
      team_member: TeamMember.find(rand(1..TeamMember.count)),
    )
  end

  Config::PAST_AFFIRMATIONS.times.each do |index|
    text = if index < (Config::PAST_AFFIRMATIONS / 4)
      Faker::Quotes::Shakespeare.hamlet_quote
    elsif index < (Config::PAST_AFFIRMATIONS / 2)
      Faker::Quotes::Shakespeare.as_you_like_it_quote
    elsif index < ((Config::PAST_AFFIRMATIONS / 4) * 3)
      Faker::Quotes::Shakespeare.romeo_and_juliet_quote
    else
      Faker::Quotes::Shakespeare.king_richard_iii_quote
    end
    text.gsub! ';', ':'
    Affirmation.create!(
      text: text,
      scheduled_date: Date.current - (index.days + 1),
      team_member: TeamMember.find(rand(1..TeamMember.count)),
    )
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
