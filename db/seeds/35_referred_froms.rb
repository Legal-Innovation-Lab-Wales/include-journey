if ReferredFrom.count.zero?
  print "#{pretty_print_name('Referred From')}\tStart: #{pretty_print(Time.now - @start_time)}"

  ReferredFrom.create!(name: 'Bro Myrddin')
  ReferredFrom.create!(name: 'Coastal housing')
  ReferredFrom.create!(name: 'FHA')
  ReferredFrom.create!(name: 'Gouledy')
  ReferredFrom.create!(name: 'Hafan')
  ReferredFrom.create!(name: 'Hafod')
  ReferredFrom.create!(name: 'Linc cymru')
  ReferredFrom.create!(name: 'Local Authority NPT')
  ReferredFrom.create!(name: 'Local authority Swansea')
  ReferredFrom.create!(name: 'Melin Homes')
  ReferredFrom.create!(name: 'POBL')
  ReferredFrom.create!(name: 'Wallich')
  ReferredFrom.create!(name: 'Plattform')
  ReferredFrom.create!(name: 'Tai Tarian')
  ReferredFrom.create!(name: 'Owner occupier')
  ReferredFrom.create!(name: 'PRS')

  User.all.each do |user|
    user.referred_from = ReferredFrom.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
