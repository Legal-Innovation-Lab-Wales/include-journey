class Notification < ApplicationRecord
  belongs_to :team_member

  def self.create_for_all_teammembers
    TeamMember.find_each do |team_member|
      # Create a new notification for the team member here
      Notification.create!(team_member: team_member, message: "Your six-month update!")
    end
  end
end
