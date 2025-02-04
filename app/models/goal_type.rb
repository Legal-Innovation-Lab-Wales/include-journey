# frozen_string_literal: true

# app/models/goal_type.rb
class GoalType < ApplicationRecord
  validates :name, :emoji, presence: true
end
