# app/models/diary_entry.rb
class DiaryEntry < PermissionRecord
  belongs_to :user
  validates_format_of :entry, with: Rails.application.config.regex_text_field,
                              message: Rails.application.config.text_field_error
  
  has_many :diary_entry_permissions, foreign_key: :diary_entry_id, dependent: :delete_all
  has_many :diary_entry_view_logs, foreign_key: :diary_entry_id, dependent: :delete_all

  after_create :update_cache

  scope :created_in_last_week, -> { where('diary_entries.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('diary_entries.created_at >= ?', 1.month.ago) }

  # <!-- 🥳,☺️,😔,😠,💩,😐 -->
  FEELING_OPTIONS = [
    '😔',
    '😐',
    '😠',
    '💩',
    '🥳',
    '😊'
  ].freeze

  validates :feeling, inclusion: { in: FEELING_OPTIONS, message: 'Please select a valid feeling from the list' }

  def permissions
    diary_entry_permissions
  end

  def to_csv
    [id, created, feeling, entry] + user.to_csv
  end

  def json
    {
      'ID': id,
      'Date': created,
      'Feeling': feeling,
      'Entry': entry
    }
      .merge(user.json.transform_keys { |key| "User #{key}" })
  end

  private

  def update_cache
    user.update!(last_diary_entry_at: Date.today,
                 diary_entries_count: user.diary_entries_count + 1,
                 diary_entries_this_month_count: user.diary_entries_this_month_count + 1)
  end
end
