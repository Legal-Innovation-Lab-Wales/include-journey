# frozen_string_literal: true

# app/models/support_ending_reason.rb
class SupportEndingReason < ApplicationRecord
  has_one :user

  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
