# frozen_string_literal: true

class GoalPermission < ApplicationRecord
  belongs_to :user
  belongs_to :team_member

  scope :short_term, -> { where(short_term: true) }
  scope :long_term, -> { where(long_term: true) }
end
