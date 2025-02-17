# frozen_string_literal: true

# app/models/diary_entry.rb
class DiaryEntry < PermissionRecord
  belongs_to :user
  validates :entry, format: {with: Rails.application.config.regex_text_field, message: Rails.application.config.text_field_error}

  has_many :diary_entry_permissions, dependent: :delete_all
  has_many :diary_entry_view_logs, dependent: :delete_all

  after_create :update_cache

  scope :created_in_last_week, -> { where(diary_entries: {created_at: 1.week.ago..}) }
  scope :created_in_last_month, -> { where(diary_entries: {created_at: 1.month.ago..}) }

  # <!-- 🥳,☺️,😔,😠,💩,😐 -->
  FEELING_OPTIONS = [
    '😔',
    '😐',
    '😠',
    '💩',
    '🥳',
    '😊',
  ].freeze

  validates :feeling, inclusion: {in: FEELING_OPTIONS, message: 'Please select a valid feeling from the list'}

  def permissions
    diary_entry_permissions
  end

  def view_logs
    diary_entry_view_logs
  end

  def give_permission(team_member)
    diary_entry_permissions.find_or_create_by!(team_member: team_member)
  end

  def log_view(team_member)
    view_log = diary_entry_view_logs.find_or_create_by!(team_member: team_member)
    view_log.increment_view_count
    view_log.save!
  end

  def visible_to?(team_member)
    diary_entry_permissions
      .where(team_member_id: team_member.id)
      .exists?
  end

  def viewed_by?(team_member)
    diary_entry_view_logs
      .where(team_member_id: team_member.id)
      .exists?
  end

  def to_csv
    [id, created, feeling, entry] + user.to_csv
  end

  def json
    {
      ID: id,
      Date: created,
      Feeling: feeling,
      Entry: entry,
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
  end

  private

  def update_cache
    user.update!(
      last_diary_entry_at: Date.current,
      diary_entries_count: user.diary_entries_count + 1,
      diary_entries_this_month_count: user.diary_entries_this_month_count + 1,
    )
  end
end
