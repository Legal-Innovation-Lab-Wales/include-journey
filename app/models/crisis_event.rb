class CrisisEvent < ApplicationRecord
  belongs_to :user
  belongs_to :crisis_type
end
