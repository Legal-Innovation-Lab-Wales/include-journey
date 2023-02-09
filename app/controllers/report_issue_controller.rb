# app/controllers/report_issue_controller.rb
class ReportIssueController < ApplicationController
  def send_report
    if validate_report(params[:report])
      ReportsMailer.with(params[:report]).report_issue_email(
        current_team_member ? current_team_member.email : current_user.email
      ).deliver_now
      redirect_back(fallback_location: root_path, flash: { success: 'Report submitted, you shall receive a reply within
        2 working days' })
    else
      redirect_back(fallback_location: root_path, flash: { alert: 'Report failed to send: Please only use regular
        characters and punctuation' })
    end
  end

  def validate_report(report)
    return false unless report[:type].match(Rails.application.config.regex_name)
    return false unless report[:body].match(Rails.application.config.regex_text_field)

    true
  end
end
