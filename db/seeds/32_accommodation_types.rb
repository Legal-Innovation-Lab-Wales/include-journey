if AccommodationType.count.zero?
  print "#{pretty_print_name('Accommodation Types')}\tStart: #{pretty_print(Time.now - @start_time)}"

  AccommodationType.create!(name: 'Living with friends')
  AccommodationType.create!(name: 'Local authority General needs tenancy')
  AccommodationType.create!(name: 'Mobile home / Caravan')
  AccommodationType.create!(name: 'Owner occupation')
  AccommodationType.create!(name: 'Prison')
  AccommodationType.create!(name: 'Private sector rental')
  AccommodationType.create!(name: 'Residential care home')
  AccommodationType.create!(name: 'Rough Sleeping')
  AccommodationType.create!(name: 'Sofa Surfing')
  AccommodationType.create!(name: 'Short term Temporary accommodation')
  AccommodationType.create!(name: 'Bed and Breakfast')
  AccommodationType.create!(name: 'Emergency Beds')
  AccommodationType.create!(name: 'Sleeping on public transport')
  AccommodationType.create!(name: 'Supported Housing ( Short Term)')
  AccommodationType.create!(name: 'Supported Housing ( Long Term)')
  AccommodationType.create!(name: "Tied Housing to employment's")
  AccommodationType.create!(name: 'Womans Refuge')
  AccommodationType.create!(name: 'Other Temporary accommodation')
  AccommodationType.create!(name: 'Client did not wish to disclose')
  AccommodationType.create!(name: 'Approved Premises /Probation hostel')
  AccommodationType.create!(name: "Children's home / foster care.")
  AccommodationType.create!(name: 'Housing association tenancy')
  AccommodationType.create!(name: '55+ accommodation / sheltered living')
  AccommodationType.create!(name: 'Living with Parents / family')

  User.all.each do |user|
    user.accommodation_type = AccommodationType.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
