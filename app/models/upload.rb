# frozen_string_literal: true

# app/models/upload.rb
class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  has_many :photos

  validates_presence_of :status, :added_by
  validates :status, inclusion: { in: %w[pending approved rejected] }
  validates :added_by, inclusion: { in: %w[user team_member] }

  after_create :approve_if_added_by_team_member

  private

  def approve_if_added_by_team_member
    self.status = 'approved' if added_by == 'team_member'
  end

  def grab_photo
    if photos.first.nil?
      return '<i class="fas fa-image"></i>'.html_safe
    end

    ('<img class="img-fluid" src="data:image/jpg;base64,%s">' % Base64.encode64(photos.first.data)).html_safe
  end
end
