class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: 'include-journey-demo@legaltech.wales'
  layout 'mailer'
end
