# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: 'notification@emails.journey.include-uk.com'
  layout 'mailer'
end
