# app/helpers/application_helper.rb
module ApplicationHelper

  def dashboard_controller?
    controller_name == "dashboard"
  end

  def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info',
      congratulations: 'alert-success'
    }[flash_type.to_sym] || flash_type.to_s
  end

end
