# frozen_string_literal: true

print "#{pretty_print_name('Team Members')}\tStart: #{pretty_print(Time.now - @start_time)}"
if TeamMember.find_by(email: 'philr@purpleriver.dev').blank?
  team_member = TeamMember.new(
    first_name: 'Phil',
    last_name: 'Reynolds',
    email: 'philr@purpleriver.dev',
    mobile_number: '07888777666',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'a.j.wing@swansea.ac.uk').blank?
  team_member = TeamMember.new(
    first_name: 'Alex',
    last_name: 'Wing',
    email: 'a.j.wing@swansea.ac.uk',
    mobile_number: '07777666555',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'ieuan.skinner@swansea.ac.uk').blank?
  team_member = TeamMember.new(
    first_name: 'Ieuan',
    last_name: 'Skinner',
    email: 'ieuan.skinner@swansea.ac.uk',
    mobile_number: '07666555444',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'benmharrison@me.com').blank?
  team_member = TeamMember.new(
    first_name: 'Ben',
    last_name: 'Harrison',
    email: 'benmharrison@me.com',
    mobile_number: '07555444333',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'g.d.andrews@swansea.ac.uk').blank?
  team_member = TeamMember.new(
    first_name: 'Gareth',
    last_name: 'Andrews',
    email: 'g.d.andrews@swansea.ac.uk',
    mobile_number: '07890123456',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 't.b.sheerhardwick@swansea.ac.uk').blank?
  team_member = TeamMember.new(
    first_name: 'Tobias',
    last_name: 'Sheer Hardwick',
    email: 't.b.sheerhardwick@swansea.ac.uk',
    mobile_number: '07890123456',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'a.a.finbarrs-ezema@swansea.ac.uk').blank?
  team_member = TeamMember.new(
    first_name: 'Amara',
    last_name: 'Finbarrs-Ezema',
    email: 'a.a.finbarrs-ezema@swansea.ac.uk',
    mobile_number: '07572416675',
    admin: true,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'amarafinbarrs123@gmail.com').blank?
  team_member = TeamMember.new(
    first_name: 'Amara',
    last_name: 'Finbarrs-Ezema',
    email: 'amarafinbarrs123@gmail.com',
    mobile_number: '07572416675',
    admin: false,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

if TeamMember.find_by(email: 'admin@myjourney.app').blank?
  team_member = TeamMember.new(
    first_name: 'Admin',
    last_name: 'Account',
    email: 'admin@myjourney.app',
    mobile_number: '07572675416',
    admin: false,
    approved: true,
    terms: true,
    suspended: false,
    password: 'password',
  )
  team_member.skip_confirmation!
  team_member.save!
end

@last_time = Time.now
puts "\tDuration: #{pretty_print(Time.now - @last_time)}   Elapsed: #{pretty_print(Time.now - @start_time)}"
