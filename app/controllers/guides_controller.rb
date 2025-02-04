# frozen_string_literal: true

# app/controllers/users/dashboard_controller.rb
class GuidesController < ApplicationController
  before_action :set_breadcrumbs

  def index
    render template: 'guide/index'
  end

  def diary
    add_breadcrumb('Diary', nil, 'fas fa-book')
    render template: 'guide/diary'
  end

  def appointments
    add_breadcrumb('My Appointments', nil, 'fas fa-calendar-alt')
    render template: 'guide/appointments'
  end

  def myNeeds
    add_breadcrumb('My Needs', nil, 'fas fa-heart')
    render template: 'guide/my_needs'
  end

  def contacts
    add_breadcrumb('My Contacts', nil, 'fas fa-address-book')
    render template: 'guide/contacts'
  end

  def support
    add_breadcrumb('My Support', nil, 'fas fa-info-circle')
    render template: 'guide/support'
  end

  def goals
    add_breadcrumb('My Goals', nil, 'fas fa-tasks')
    render template: 'guide/goals'
  end

  def set_breadcrumbs
    path = action_name == 'index' ? nil : 'guide'
    add_breadcrumb('Guide', path, 'fas fa-question-circle')
  end
end
