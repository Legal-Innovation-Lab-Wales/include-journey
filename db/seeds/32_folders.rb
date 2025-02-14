# frozen_string_literal: true

if Folder.none?
  print "#{pretty_print_name('Folders')}\tStart: #{pretty_print(Time.current - @start_time)}"

  team_member = TeamMember.find_by(email: 'a.a.finbarrs-ezema@swansea.ac.uk')
  30.times do
    top_folder = Folder.create!(
      name: Faker::Name.first_name,
      team_member: team_member,
    )
    30.times do
      child_folder1 = Folder.create!(
        name: Faker::Name.first_name,
        parent_folder: top_folder,
        team_member: team_member,
      )
      5.times do
        Folder.create!(
          name: Faker::Name.first_name,
          parent_folder: child_folder1,
          team_member: team_member,
        )
      end
    end
  end

  puts "\tDuration: #{pretty_print(Time.current - @last_time)}   Elapsed: #{pretty_print(Time.current - @start_time)}"
  @last_time = Time.current
end
