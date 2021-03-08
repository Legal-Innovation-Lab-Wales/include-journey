class PagesController < ApplicationController
  def main
    if session[:awaiting_approval_notice].present?
      flash.now[:alert] = session[:awaiting_approval_notice]
      session.delete(:awaiting_approval_notice)
    end
    render template: 'pages/main'
  end
end
