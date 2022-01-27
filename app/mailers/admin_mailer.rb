# app/mailers/admin_mailer.rb
class AdminMailer < ApplicationMailer
  def new_team_member_email(team_member, admin, unapproved_count)
    @team_member = team_member
    @admin = admin
    @unapproved_count = unapproved_count
    mail(to: @admin.email, subject: 'New Team Member on Include Journey')
  end

  def new_crisis_email(user, admin, crisis_event, crisis_type)
    @admin = admin
    @user = user
    @crisis_event = crisis_event
    @crisis_type = crisis_type
    mail(to: @admin.email, subject: " #{@user.full_name} is having a crisis - SOS Button Pushed")
  end

  def updated_crisis_email(user, admin, crisis_event, crisis_type, crisis_notes)
    @admin = admin
    @user = user
    @crisis_event = crisis_event
    @crisis_type = crisis_type
    @crisis_notes = crisis_notes
    mail(to: @admin.email, subject: " #{@user.full_name}'s crisis has been updated.")
  end

  def reminder_email(user)
    @user = user
    mail(to: @user.email, subject: 'Wellbeing Assessment Reminder!')
  end
end
