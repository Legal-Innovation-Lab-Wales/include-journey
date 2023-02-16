# app/mailers/admin_mailer.rb
class UserMailer < ApplicationMailer

  def approved(user)
    @recipient = user

    mail(to: @recipient.email, subject: 'Your signup has been approved')
  end

  def rejected(user)
    @recipient = user

    mail(to: @recipient.email, subject:'Your signup has not been approved')
  end

  def suspended(user)
    @recipient = user
    @keyword = @recipient.suspended ? "suspended" : "reinstated"

    mail(to: @recipient.email, subject:"Your account has been #{@keyword}")
  end
end
