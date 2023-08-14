# lib/clock.rb
require 'clockwork'
require_relative '../config/boot'
require_relative '../config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'team_members_notifications') do
    Notification.create_for_all_teammembers
  end
end
