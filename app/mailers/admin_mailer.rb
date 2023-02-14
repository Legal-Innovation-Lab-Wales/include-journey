# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer

  def new_team_member_email(team_member, admin, unapproved_count, isUser=false)
    @team_member = team_member
    @admin = admin
    @unapproved_count = unapproved_count
    @userType = isUser ? "User" : "Team Member";
    @isUser = isUser
    @url = isUser ? approvals_url : team_members_url;
    mail(to: @admin.email, subject: "New #{@userType} on Include Journey")
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Wellbeing Assessment Reminder!')
  end
end
