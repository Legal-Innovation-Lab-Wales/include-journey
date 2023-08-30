# app/models/support_ending_reason.rb
class SupportEndingReason < ApplicationRecord
  has_one :user

  validates_presence_of :name

  def json
    {
      'name': name
    }
  end

  def to_csv
    [name]
  end
end
