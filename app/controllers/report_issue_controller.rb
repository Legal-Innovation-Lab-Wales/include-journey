# app/controllers/report_issue_controller.rb
class ReportIssueController < ApplicationController
  def send_report
    if validate_report(params[:report])
      email = (current_team_member || current_user).email
      ReportsMailer.with(params[:report])
        .report_issue_email(email)
        .deliver_now

      flash = {success: 'Report submitted, you shall receive a reply within 2 working days'}
    else
      flash = {alert: 'Report failed to send: Please only use regular characters and punctuation'}
    end
    redirect_back(fallback_location: root_path, flash: flash)
  end

  def validate_report(report)
    return false unless report[:type].match(Rails.application.config.regex_name)
    return false unless report[:body].match(Rails.application.config.regex_text_field)

    true
  end
end
