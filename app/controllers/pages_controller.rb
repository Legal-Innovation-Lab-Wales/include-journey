# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def main
    if session[:sign_out_notice].present?
      flash.now[:alert] = session[:sign_out_notice]
      session.delete(:sign_out_notice)
    end

    render template: 'pages/main'
  end
end
