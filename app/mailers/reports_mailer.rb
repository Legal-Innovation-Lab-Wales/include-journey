# app/mailers/reports_mailer.rb
class ReportsMailer < ApplicationMailer
  def report_issue_email(email)
    @type = params[:type]
    @body = params[:body]
    @email = email
    mail(to: ENV['REPORT_EMAIL'], from: @email, subject: "Issue Reported: #{@type}")
  end
end
