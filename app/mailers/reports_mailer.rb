# app/mailers/reports_mailer.rb
class ReportsMailer < ApplicationMailer
  def report_issue_email(email)
    @type = params[:type]
    @body = "#{email} \n #{params[:body]}"
    mail(to: ENV['REPORT_EMAIL'], subject: "Issue Reported: #{@type}")
  end
end
