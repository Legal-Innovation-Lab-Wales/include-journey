# frozen_string_literal: true

# app/models/wellbeing_service.rb
class WellbeingService < ApplicationRecord
  belongs_to :team_member

  has_many :metrics_services
  has_many :wellbeing_metrics, through: :metrics_services

  before_save :fetch_long_and_lat

  validates :name, :website, presence: true
  validates :name, format: {
    with: Rails.application.config.regex_name,
    message: Rails.application.config.name_error,
  }
  validates :description, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :website, format: {
    with: Rails.application.config.regex_website,
    message: Rails.application.config.website_error,
  }
  validates :contact_number, format: {
    with: Rails.application.config.regex_telephone,
    message: Rails.application.config.telephone_error,
  }
  validates :postcode, format: {
    with: Rails.application.config.regex_postcode,
    message: Rails.application.config.postcode_error,
  }
  validates :address, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }

  attr_accessor :distance

  def linked(wellbeing_metric_id)
    metrics_services.any? { |ms| ms.wellbeing_metric_id == wellbeing_metric_id }
  end

  def unlink_metric(wellbeing_metric_id)
    return unless linked(wellbeing_metric_id)

    metrics_services.find_by(wellbeing_metric_id: wellbeing_metric_id).destroy!
  end

  def link_metric(wellbeing_metric_id)
    return if linked(wellbeing_metric_id)

    metrics_services.create!(wellbeing_metric_id: wellbeing_metric_id)
  end

  def metrics
    wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" }
  end

  def recommend?
    recommend
  end

  private

  def fetch_long_and_lat
    postcode_data = get_codes(postcode.delete(' '))
    if postcode_data['error']
      postcode_error
    else
      result = postcode_data['result']
      self.longitude = result['longitude']
      self.latitude = result['latitude']
      true
    end
  end

  def get_codes(code)
    RestClient.get("#{ENV.fetch('POSTCODE_API')}#{code}") do |response, _request, _result|
      case response.code
      when 200...300
        JSON.parse response
      else
        postcode_error
      end
    end
  rescue StandardError
    postcode_error
  end

  def postcode_error
    errors.add(:postcode, 'Could not retrieve postcode information, please include a complete postcode')
    throw(:abort)
  end
end
