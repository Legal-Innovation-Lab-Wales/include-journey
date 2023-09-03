if WallichLocalAuthority.count.zero?
  print "#{pretty_print_name('Local Authorities')}\tStart: #{pretty_print(Time.now - @start_time)}"

  WallichLocalAuthority.create!(name: 'Swan')
  WallichLocalAuthority.create!(name: 'NPT')
  WallichLocalAuthority.create!(name: 'Other')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
