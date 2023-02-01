class WellbeingScoreValue < ApplicationRecord
    validates_format_of :name, with: Rails.application.config.regex_name, on: :update
end
