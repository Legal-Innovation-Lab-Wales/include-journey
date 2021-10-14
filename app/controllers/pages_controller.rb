# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def main
    render template: 'pages/main'
  end
end
