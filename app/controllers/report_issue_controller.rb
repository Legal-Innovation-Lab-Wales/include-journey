# app/controllers/report_issue_controller.rb
class ReportIssueController < ApplicationController
  def send_report
    ReportsMailer.with(params[:report]).report_issue_email.deliver_now
    redirect_back(fallback_location: root_path, flash: { success: "Report sent!" })
  end
end
