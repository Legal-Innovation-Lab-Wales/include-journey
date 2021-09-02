# app/models/achievement.rb
class Achievement < ApplicationRecord
  has_many :user_achievements
  has_many :users, through: :user_achievements

  scope :all_time, -> { where(start_date: nil) }
  scope :this_month, -> { where('start_date = ? and end_date = ?', Date.today.at_beginning_of_month, Date.today.at_end_of_month) }

  validates_presence_of :name, :description, :resource, :count
end
