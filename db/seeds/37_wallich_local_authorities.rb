# frozen_string_literal: true

if WallichLocalAuthority.count.zero?
  print "#{pretty_print_name('Local Authorities')}\tStart: #{pretty_print(Time.current - @start_time)}"

  WallichLocalAuthority.create!(name: 'Swan')
  WallichLocalAuthority.create!(name: 'NPT')
  WallichLocalAuthority.create!(name: 'Other')

  User.find_each do |user|
    user.wallich_local_authority = WallichLocalAuthority.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
