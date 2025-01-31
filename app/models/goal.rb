# app/models/goal.rb
class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :goal_type

  before_update :update_cache, if: -> { achieved_on_changed? }

  scope :short_term, -> { where(short_term: true) }
  scope :long_term, -> { where(short_term: false) }
  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  validates :user_id, :goal, :goal_type, presence: true
  validates :goal, format: {with: Rails.application.config.regex_text_field}

  def achieved?
    achieved_on.present?
  end

  def achieved
    return '' unless achieved_on.present?

    achieved_on.strftime('%d/%m/%Y %I:%M %p')
  end

  private

  def update_cache
    user.update!(
      last_goal_achieved_at: Date.today,
      goals_achieved_count: user.goals_achieved_count + 1,
      goals_achieved_this_month_count: user.goals_achieved_this_month_count + 1,
    )
  end
end
