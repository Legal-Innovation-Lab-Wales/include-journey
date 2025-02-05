# frozen_string_literal: true

# app/models/achievement.rb
class Achievement < ApplicationRecord
  has_many :user_achievements
  has_many :users, through: :user_achievements

  scope :all_time, -> { where(starts_at: nil) }
  scope :this_month, lambda {
    where('starts_at = ? and ends_at = ?', Date.current.at_beginning_of_month, Date.current.at_end_of_month)
  }
  scope :for, ->(entities) { where(entities: entities).first }
  scope :available, -> { all_time.merge(this_month) }

  validates :name, :description, :entities, :bronze_count, :silver_count, :gold_count, presence: true

  def check(user)
    count = starts_at.present? ? user["#{entities}_this_month_count"] : user["#{entities}_count"]

    return unless count >= bronze_count

    achievement = user_achievements.find_or_create_by!(user: user)

    return if achievement.gold_achieved

    ['bronze', 'silver', 'gold'].each do |medal|
      next if achievement["#{medal}_achieved"] || count < self["#{medal}_count"]

      achievement.update!("#{medal}_achieved" => true)
    end
  end
end
