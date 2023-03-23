class Tag < ApplicationRecord
  belongs_to :team_member
  has_many :user_tags, foreign_key: :tag_id

  scope :created_in_last_week, -> { where('tags.created_at >= ?', 7.days.ago) }
  scope :created_in_last_month, -> { where('tags.created_at >= ?', 1.month.ago) }
  scope :tagged, -> { joins(:user_tags) }
  scope :tagged_in_last_week, -> { joins(:user_tags).where('user_tags.created_at >= ?', 7.days.ago) }
  scope :tagged_in_last_month, -> { joins(:user_tags).where('user_tags.created_at >= ?', 1.month.ago) }

  validates_presence_of :tag, :team_member_id
  validates_format_of :tag, with: Rails.application.config.regex_name,
                            message: Rails.application.config.name_error
  validates_uniqueness_of :tag
end
