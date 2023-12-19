class OccupationalTherapistMetric < ApplicationRecord
  has_many :ota_entries

  validates_presence_of :name
  validates_format_of :name, with: Rails.application.config.regex_name,
                             message: Rails.application.config.name_error
end
