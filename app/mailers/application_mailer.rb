# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: 'include-journey-demo@legaltech.wales'
  layout 'mailer'
end
