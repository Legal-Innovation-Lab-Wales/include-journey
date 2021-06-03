module TeamMembers
  # app/controllers/team_members/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    include Accessible
    skip_before_action :check_user, except: %i[new create]

    after_action :send_new_team_member_email, only: :create

    private

    def send_new_team_member_email
      return unless @team_member.created_at? || Time.now - TeamMember.second_to_last.created_at < 6.hours

      unapproved_count = TeamMember.unapproved.count
      TeamMember.admins.each do |admin|
        AdminMailer.new_team_member_email(@team_member, admin, unapproved_count).deliver_later
      end
    end
  end
end
