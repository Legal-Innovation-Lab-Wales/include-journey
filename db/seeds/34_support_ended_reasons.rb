if SupportEndingReason.count.zero?
  print "#{pretty_print_name('Reasons For Ending Support')}\tStart: #{pretty_print(Time.now - @start_time)}"

  SupportEndingReason.create!(name: 'Bro Myrddin')
  SupportEndingReason.create!(name: 'Coastal housing')
  SupportEndingReason.create!(name: 'FHA')
  SupportEndingReason.create!(name: 'Gouledy')
  SupportEndingReason.create!(name: 'Hafan')
  SupportEndingReason.create!(name: 'Hafod')
  SupportEndingReason.create!(name: 'Linc cymru')
  SupportEndingReason.create!(name: 'Local Authority NPT')
  SupportEndingReason.create!(name: 'Local authority Swansea')
  SupportEndingReason.create!(name: 'Melin Homes')
  SupportEndingReason.create!(name: 'POBL')
  SupportEndingReason.create!(name: 'Wallich')
  SupportEndingReason.create!(name: 'Plattform')
  SupportEndingReason.create!(name: 'Tai Tarian')
  SupportEndingReason.create!(name: 'Owner occupier')
  SupportEndingReason.create!(name: 'PRS')

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
