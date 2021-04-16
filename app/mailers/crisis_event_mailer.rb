# app/mailers/crisis_event_mailer.rb
class CrisisEventMailer < ApplicationMailer

  def new_crisis_email
    @admin = params[:admin]
    @user = params[:user]
    @crisis_event = params[:crisis_event]
    @crisis_type = params[:crisis_type]
    mail(to: @admin.email, subject: " #{@user.full_name} is having a crisis - SOS Button Pushed")
  end

end
