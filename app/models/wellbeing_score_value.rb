class WellbeingScoreValue < ApplicationRecord
  validates :name, format: {with: Rails.application.config.regex_name}
end
