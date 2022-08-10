# app/controllers/report_issue_controller.rb
class ReportIssueController < ApplicationController
  def send_report
    puts('A report has been received')
    puts('The type is: ' + params[:report][:type].to_s)
    redirect_back(fallback_location: root_path)
  end
end
