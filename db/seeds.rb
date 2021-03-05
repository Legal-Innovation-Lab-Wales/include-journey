# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# Create users
#Create Static Users
team_member = TeamMember.new(
  first_name: 'Phil',
  last_name: 'Reynolds',
  email: 'philr@purpleriver.dev',
  mobile_number: '07888777666',
  admin: true,
  terms: true,
  password: 'password'
)
team_member.skip_confirmation!
team_member.save!

team_member = TeamMember.new(
  first_name: 'Alex',
  last_name: 'Wing',
  email: 'a.j.wing@swansea.ac.uk',
  mobile_number: '07777666555',
  admin: true,
  terms: true,
  password: 'password'
)
team_member.skip_confirmation!
team_member.save!

team_member = TeamMember.new(
  first_name: 'Ieuan',
  last_name: 'Skinner',
  email: 'ieuan.skinner@swansea.ac.uk',
  mobile_number: '07666555444',
  admin: true,
  terms: true,
  password: 'password'
)
team_member.skip_confirmation!
team_member.save!

team_member = TeamMember.new(
  first_name: 'Ben',
  last_name: 'Harrison',
  email: 'benmharrison@me.com',
  mobile_number: '07555444333',
  admin: true,
  terms: true,
  password: 'password'
)
team_member.skip_confirmation!
team_member.save!


10.times do
  user = User.new(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    email: Faker::Internet.unique.email,
    mobile_number: Faker::Number.leading_zero_number(digits: 11),
    release_date: rand(1..2).even? ? Faker::Date.between(from: '20201-03-05', to: '2025-03-05') : '',
    terms: true,
    password: 'password'
  )
  user.skip_confirmation!
  user.save!

end


