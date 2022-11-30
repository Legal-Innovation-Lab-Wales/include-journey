# app/controllers/report_issue_controller.rb
class ReportIssueController < ApplicationController
  def send_report
    ReportsMailer.with(params[:report]).report_issue_email(
      current_team_member ? current_team_member.email : current_user.email
    ).deliver_now
    redirect_back(fallback_location: root_path, flash: { success: 'Report submitted, you shall receive a reply within
      2 working days' })
  end
end
