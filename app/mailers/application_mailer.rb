# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: 'journey@legaltech.wales'
  layout 'mailer'
end
