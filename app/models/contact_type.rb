# app/models/contact_type.rb
class ContactType < ApplicationRecord
  validates_presence_of :name

  def json
    {
      'id': id,
      'name': name,
      'color': color
    }
  end

  def to_csv
    [id, name, color]
  end
end
