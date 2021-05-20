# app/controllers/users/dashboard_controller.rb
class GuidesController < ApplicationController
  def index
    render template: 'guide/index'
  end

  def journal
    render template: 'guide/journal'
  end
end
