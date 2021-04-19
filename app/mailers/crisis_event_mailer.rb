# app/mailers/crisis_event_mailer.rb
class CrisisEventMailer < ApplicationMailer

  def new_crisis_email(user, admin, crisis_event, crisis_type)
    @admin = admin
    @user = user
    @crisis_event = crisis_event
    @crisis_type = crisis_type
    mail(to: @admin.email, subject: " #{@user.full_name} is having a crisis - SOS Button Pushed")
  end

end
