# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :replaced_by, class_name: 'Note', optional: true, foreign_key: 'replaced_by_id'
  belongs_to :replacing, class_name: 'Note', optional: true, foreign_key: 'replacing_id'
  has_one :message, dependent: :destroy

  validates_presence_of :team_member_id, :user_id, :content, :dated
  validates_format_of :content, with: Rails.application.config.regex_text_field,
                                message: Rails.application.config.text_field_error
  validates_format_of :dated, with: Rails.application.config.regex_datetime,
                              message: Rails.application.config.datetime_error

  scope :past_dated, -> { where('dated <= ? ', 1.month.ago) }
  scope :past_created, -> { where('notes.created_at <= ?', 1.month.ago) }
  scope :recent, -> { where('dated >= :one_month or notes.created_at >= :one_month', :one_month  => 1.month.ago) }


  def chain(array)
    array << self
    return unless replacing.present?

    replacing.chain(array)
  end

  def latest
    return self if replaced_by.nil?

    replaced_by.latest
  end

  def changes?(note_params)
    content != note_params[:content] || visible_to_user != note_params[:visible_to_user] || dated != note_params[:dated]
  end

  def created
    if self.dated.present?
      self.dated.strftime('%d/%m/%Y %I:%M %p')
    else
      created_at.strftime('%d/%m/%Y %I:%M %p')
    end
  end

  def date
    self.dated.present? ? self.dated.strftime('%Y-%m-%d') : Date.today.strftime('%Y-%m-%d')
  end

  def time
    self.dated.present? ? self.dated.strftime('%H:%M') : Time.now.strftime('%H:%M')
  end

  def dated?
    self.dated.present?
  end
end
