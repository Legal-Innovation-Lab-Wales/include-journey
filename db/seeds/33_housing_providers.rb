if HousingProvider.count.zero?
  print "#{pretty_print_name('Housing Providers')}\tStart: #{pretty_print(Time.now - @start_time)}"

  HousingProvider.create!(name: 'Bro Myrddin')
  HousingProvider.create!(name: 'Coastal housing')
  HousingProvider.create!(name: 'FHA')
  HousingProvider.create!(name: 'Gouledy')
  HousingProvider.create!(name: 'Hafan')
  HousingProvider.create!(name: 'Hafod')
  HousingProvider.create!(name: 'Linc cymru')
  HousingProvider.create!(name: 'Local Authority NPT')
  HousingProvider.create!(name: 'Local authority Swansea')
  HousingProvider.create!(name: 'Melin Homes')
  HousingProvider.create!(name: 'POBL')
  HousingProvider.create!(name: 'Wallich')
  HousingProvider.create!(name: 'Plattform')
  HousingProvider.create!(name: 'Tai Tarian')
  HousingProvider.create!(name: 'Owner occupier')
  HousingProvider.create!(name: 'PRS')

  User.all.each do |user|
    user.housing_provider = HousingProvider.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
