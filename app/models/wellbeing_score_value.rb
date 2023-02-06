class WellbeingScoreValue < ApplicationRecord
    validates_format_of :name, with: Rails.application.config.regex_name
    validates :value, numericality: { only_integer: true, greater_than: 0, less_than: 11,
                                      message: 'Use sliders to set value' }
end
