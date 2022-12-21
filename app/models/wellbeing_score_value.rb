class WellbeingScoreValue < ApplicationRecord
    validates_format_of :name, with: /\A[a-zA-Z]*\z/, on: :update
end
