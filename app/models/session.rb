# app/models/session.rb
class Session < ApplicationRecord
  belongs_to :user

  after_create :increment_cache
  before_destroy :decrement_cache

  validates_presence_of :session_at

  private

  def increment_cache
    user.update!(last_session_at: session_at, sessions_count: user.sessions_count + 1, sessions_streak: sessions_streak)
  end

  def sessions_streak
    (user.last_session_at.present? && (user.last_session_at + 1.day == session_at) ? user.sessions_streak : 0) + 1
  end

  # Shouldn't ever need to be invoked.
  def decrement_cache
    user.update!(sessions_count: user.sessions_count - 1)
  end
end
