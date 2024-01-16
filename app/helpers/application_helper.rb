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

  # rubocop:disable Metrics/AbcSize
  def time_between(from, to)
    difference = to - from
    days = (difference / (1000 * 60 * 60 * 24)).floor
    hours = ((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)).floor
    minutes = ((difference % (1000 * 60 * 60)) / (1000 * 60)).floor
    seconds = ((difference % (1000 * 60)) / 1000).floor
    seconds = seconds >= 0 ? seconds : 0

    "#{get_unit(days, 'd')}#{get_unit(hours, 'h')}#{get_unit(minutes, 'm')}#{seconds}s"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def get_unit(value, unit)
    (value.positive? ? "#{value}#{unit} " : '').to_s
  end

  def wallich?
    ENV['ORGANISATION_NAME'] == 'wallich-journey'
  end
end
