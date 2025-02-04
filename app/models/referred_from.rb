# frozen_string_literal: true

# app/models/referred_from.rb
class ReferredFrom < ApplicationRecord
  has_one :user

  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
