# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def main
    render template: 'pages/main'
  end

  def terms
    add_breadcrumb('Terms', nil, 'fas fa-gavel')
    render 'pages/terms'
  end

  def privacy_notice
    add_breadcrumb('Terms', terms_path, 'fas fa-gavel')
    add_breadcrumb('Privacy Notice', nil, 'fas fa-eye')
    render 'pages/privacy_notice'
  end

  def cookie_policy
    add_breadcrumb('Terms', terms_path, 'fas fa-gavel')
    add_breadcrumb('Cookie Policy', nil, 'fas fa-cookie-bite')
    render 'pages/cookie_policy'
  end
end
