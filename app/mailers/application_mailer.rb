# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: ENV.fetch('FROM_EMAIL')
  layout 'mailer'
end
