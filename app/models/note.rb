# frozen_string_literal: true

# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :replaced_by, class_name: 'Note', optional: true
  belongs_to :replacing, class_name: 'Note', optional: true
  has_one :message, dependent: :destroy

  validates :team_member_id, :user_id, :content, :dated, presence: true
  validates :content, format: {
    with: Rails.application.config.regex_text_field,
    message: Rails.application.config.text_field_error,
  }
  validates :dated, format: {
    with: Rails.application.config.regex_datetime,
    message: Rails.application.config.datetime_error,
  }

  scope :past, -> { where('dated <= :one_month or notes.created_at <= :one_month', one_month: 1.month.ago) }

  def chain(array)
    array << self
    return if replacing.blank?

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
    if dated.present?
      dated.strftime('%d/%m/%Y %I:%M %p')
    else
      created_at.strftime('%d/%m/%Y %I:%M %p')
    end
  end

  def date
    dated.present? ? dated.strftime('%Y-%m-%d') : Date.today.strftime('%Y-%m-%d')
  end

  def time
    dated.present? ? dated.strftime('%H:%M') : Time.now.strftime('%H:%M')
  end

  def dated?
    dated.present?
  end
end
