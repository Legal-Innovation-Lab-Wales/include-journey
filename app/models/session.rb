# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user

  after_create :update_cache

  validates :session_at, presence: true

  private

  def update_cache
    user.update!(
      last_session_at: session_at,
      sessions_count: user.sessions_count + 1,
      sessions_this_month_count: user.sessions_this_month_count + 1,
      sessions_streak: sessions_streak,
    )
  end

  def sessions_streak
    if user.last_session_at.present? && (user.last_session_at + 1.day == session_at)
      user.sessions_streak + 1
    else
      1
    end
  end
end
