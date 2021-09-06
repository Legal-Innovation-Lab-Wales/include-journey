# app/models/achievement.rb
class Achievement < ApplicationRecord
  has_many :user_achievements
  has_many :users, through: :user_achievements

  scope :all_time, -> { where(starts_at: nil) }
  scope :this_month, lambda {
    where('starts_at = ? and ends_at = ?', Date.today.at_beginning_of_month, Date.today.at_end_of_month)
  }
  scope :resource, ->(resource) { where(resource: resource.name.downcase) }

  validates_presence_of :name, :description, :resource, :bronze_count, :silver_count, :gold_count
end
