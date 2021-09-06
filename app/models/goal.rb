# app/models/goal.rb
class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :goal_type

  before_update :increment_cache, if: -> { achieved_on.changed? }

  scope :short_term, -> { where(short_term: true) }
  scope :long_term, -> { where(short_term: false) }
  scope :archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

  validates_presence_of :user_id, :goal, :goal_type

  def achieved?
    achieved_on.present?
  end

  def achieved
    return '' unless achieved_on.present?

    achieved_on.strftime('%d/%m/%Y %I:%M %p')
  end

  private

  def increment_cache
    user.update!(goals_achieved_count: user.goals_achieved_count + 1,
                 goals_achieved_this_month_count: Date.today.day == 1 ? 1 : user.goals_achieved_this_month_count + 1)
  end
end
