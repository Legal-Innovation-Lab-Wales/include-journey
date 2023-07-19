class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  has_many :photos

  attributes :status, :string, default: 'pending'

  validates :status, inclusion: { in: %w[pending approved rejected] }
  validates :added_by, inclusion: { in: %w[user team_member] }

  after_create :approve_if_added_by_team_member

  private

  def approve_if_added_by_team_member
    self.status = 'approved' if added_by == 'team_member'
  end
end
