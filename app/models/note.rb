# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
  belongs_to :replaced_by, class_name: 'Note', optional: true, foreign_key: 'replaced_by_id'
  belongs_to :replacing, class_name: 'Note', optional: true, foreign_key: 'replacing_id'

  validates_presence_of :team_member_id, :user_id, :content

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
    content != note_params[:content] || visible_to_user != note_params[:visible_to_user] || optional_date != note_params[:optional_date]
  end

  def created
    if self.optional_date.present?
      self.optional_date.strftime('%d/%m/%Y %I:%M %p')
    else
      created_at.strftime('%d/%m/%Y %I:%M %p')
    end
  end

  def date
    self.optional_date.present? ? self.optional_date.strftime('%Y-%m-%d') : Date.today.strftime('%Y-%m-%d')
  end

  def time
    self.optional_date.present? ? self.optional_date.strftime('%H:%M') : Time.now.strftime('%H:%M')
  end
end
