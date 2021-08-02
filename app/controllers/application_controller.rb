# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :deletion_date, :active_crisis_events, :crisis_event, :crisis_types, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    added_attrs = %i[
      first_name last_name mobile_number release email password password_confirmation remember_me
      terms date_of_birth sex gender_identity pronouns ethnic_group religion disabilities
    ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def deletion_date
    return unless current_user.deletion_date.present?

    if current_user.deletion_date <= DateTime.now
      current_user.destroy!
      sign_out_and_redirect(current_user)
    else
      @deletion_date = current_user.deletion_date.to_f * 1000
    end
  end

  def active_crisis_events
    @active_crisis_events = current_user.active_crisis_events
  end

  def crisis_event
    @crisis_event = CrisisEvent.new
  end

  def crisis_types
    @crisis_types = CrisisType.all
  end
end
