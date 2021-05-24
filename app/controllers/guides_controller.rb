# app/controllers/users/dashboard_controller.rb
class GuidesController < ApplicationController
  def index
    render template: 'guide/index'
  end

  def journal
    render template: 'guide/journal'
  end

  def appointments
    render template: 'guide/appointments'
  end

  def myNeeds
    render template: 'guide/myNeeds'
  end

  def contacts
    render template: 'guide/contacts'
  end

  def support
    render template: 'guide/support'
  end

  def goals
    render template: 'guide/goals'
  end
end
