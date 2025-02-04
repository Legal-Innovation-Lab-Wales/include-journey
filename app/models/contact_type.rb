# frozen_string_literal: true

# app/models/contact_type.rb
class ContactType < ApplicationRecord
  validates :name, presence: true

  def json
    {
      id: id,
      name: name,
      color: color,
    }
  end

  def to_csv
    [id, name, color]
  end
end
