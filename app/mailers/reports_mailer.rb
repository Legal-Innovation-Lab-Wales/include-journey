# app/mailers/reports_mailer.rb
class ReportsMailer < ApplicationMailer
  def report_issue_email
    @type = params[:type]
    @body = params[:body]
    @email = current_team_member ? current_team_member.email : current_user.email
    mail(to: ENV['REPORT_EMAIL'], from: @email, subject: "Issue Reported: #{@type}")
  end
end
