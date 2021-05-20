# app/controllers/users/dashboard_controller.rb
class GuidesController < ApplicationController
  def index
    render template: 'guide/index'
  end
end
