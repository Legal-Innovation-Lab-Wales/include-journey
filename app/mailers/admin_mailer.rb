# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer

  def new_team_member_email(team_member, admin, unapproved_count, is_user = false)
    @team_member = team_member
    @admin = admin
    @unapproved_count = unapproved_count
    @user_type = is_user ? 'User' : 'Team Member'
    @is_user = is_user
    @url = is_user ? approvals_url : team_members_url
    mail(to: @admin.email, subject: "New #{@user_type} on Include Journey")
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Wellbeing Assessment Reminder!')
  end

  def created_user_email(team_member, user, password, is_reset)
    @team_member = team_member
    @user = user
    @password = password
    @is_reset = is_reset
    mail(to: @team_member.email, subject: "New User Created")
  end
end
