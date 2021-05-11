# app/models/goal_type.rb
class GoalType < ApplicationRecord
  validates_presence_of :name, :emoji
end
