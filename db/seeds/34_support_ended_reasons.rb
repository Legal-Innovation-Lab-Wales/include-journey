if SupportEndingReason.count.zero?
  print "#{pretty_print_name('Reasons For Ending Support')}\tStart: #{pretty_print(Time.now - @start_time)}"

  SupportEndingReason.create!(name: 'Entered a long stay hospital or hospice')
  SupportEndingReason.create!(name: 'Entered a mental health unit')
  SupportEndingReason.create!(name: 'Entered a residential detox facility')
  SupportEndingReason.create!(name: 'Entered prison/ YOL')
  SupportEndingReason.create!(name: 'Health needs have stabilised')
  SupportEndingReason.create!(name: 'Moved into a care home')
  SupportEndingReason.create!(name: 'Moved into a long term supported housing')
  SupportEndingReason.create!(name: 'Moved into a short term supported housing')
  SupportEndingReason.create!(name: 'Moved into Sheltered/Extra Care')
  SupportEndingReason.create!(name: 'Moved into Sustainable rented accommodation')
  SupportEndingReason.create!(name: 'Moved out of area (Planned)')
  SupportEndingReason.create!(name: 'Moved out of area (Unplanned)')
  SupportEndingReason.create!(name: 'Non engagement with support')
  SupportEndingReason.create!(name: 'Transferred to other agency for reduced support')
  SupportEndingReason.create!(name: 'Transferred to other agency for increased support')
  SupportEndingReason.create!(name: 'End of planned intervention (positive)')
  SupportEndingReason.create!(name: 'Housing related support needs have been met')
  SupportEndingReason.create!(name: 'Has requested for support to end')
  SupportEndingReason.create!(name: 'Deceased')

  User.all.each do |user|
    user.support_ending_reason = SupportEndingReason.all.sample
    user.save!
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
