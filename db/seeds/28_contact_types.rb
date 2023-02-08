print "#{pretty_print_name('Contact Types')}\tStart: #{pretty_print(Time.now - @start_time)}"
ContactType.where(name: 'Drop in')? ContactType.where(name: 'Drop in').update(color: "#e66043") : ContactType.create!(name: 'Drop in', color: '#e66043')
ContactType.where(name: 'Scheduled 1:1')? ContactType.where(name: 'Scheduled 1:1').update(color: "#eb7945") : ContactType.create!(name: 'Scheduled 1:1', color: '#eb7945')
ContactType.where(name: 'Telephone call')? ContactType.where(name: 'Telephone call').update(color: "#ee904b") : ContactType.create!(name: 'Telephone call', color: '#ee904b')
ContactType.where(name: 'Email')? ContactType.where(name: 'Email').update(color: "#F0A656") : ContactType.create!(name: 'Email', color: '#F0A656')
ContactType.where(name: 'Other')? ContactType.where(name: 'Other').update(color: "#DFC54C") : ContactType.create!(name: 'Other', color: '#DFC54C')
puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
@last_time = Time.now