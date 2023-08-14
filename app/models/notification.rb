class Notification < ApplicationRecord
  belongs_to :team_member
  belongs_to :user

  def self.create_for_all_teammembers
    TeamMember.find_each do |team_member|
      # Create a new notification for the team member here
      team_member.users.find_each do |user|
        if user.created_at.to_date == 6.months.ago.to_date
          Notification.create!(team_member: team_member, message: "Please check the accommodation status for:", user: user)
        end
      end
    end
  end
end
