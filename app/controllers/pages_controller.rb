# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def main
    render template: 'pages/main'
  end

  def demo_dashboard
    render template: 'pages/demo-dashboard'
  end
end
