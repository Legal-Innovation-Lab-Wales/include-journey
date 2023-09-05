if Folder.count.zero?
  print "#{pretty_print_name('Folders')}\tStart: #{pretty_print(Time.now - @start_time)}"

  5.times do
    top_folder = Folder.create!(name: Faker::Name.first_name)
    5.times do
      Folder.create!(name: Faker::Name.first_name,
                     parent_folder: top_folder)
    end
  end

  puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
  @last_time = Time.now
end
