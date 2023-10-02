# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, :sign_out_notice, if: :devise_controller?
  before_action :require_approval, :check_suspended
  before_action :deletion, :create_session, if: :user_signed_in?
  helper_method :breadcrumbs

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil, icon = nil)
    breadcrumbs << Breadcrumb.new(name, path, icon)
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[
      first_name last_name mobile_number email password password_confirmation remember_me
      terms date_of_birth sex gender_identity pronouns ethnic_group religion disabilities
      notifications_enabled summary_panel address
    ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def deletion
    return unless current_user.deleted_at.present?

    if current_user.deleted_at <= DateTime.now
      current_user.destroy!
      sign_out_and_redirect(current_user)
    else
      @deletion_date = current_user.deleted_at.to_f * 1000
    end
  end

  def create_session
    return if current_user.last_session_at == Date.today

    current_user.sessions.create!(session_at: Date.today)
  end

  def sign_out_notice
    return unless session[:sign_out_notice].present?

    flash.now[:alert] = session[:sign_out_notice]
    session.delete(:sign_out_notice)
  end

  def require_approval
    return unless current_user && !current_user.approved?

    sign_out_and_redirect(current_user)
    session[:sign_out_notice] = 'An admin needs to approve you before you can access the system.'
  end

  def check_suspended
    return unless current_user && current_user.suspended?

    sign_out_and_redirect(current_user)
    session[:sign_out_notice] = 'Your account is suspended.'
  end
end
