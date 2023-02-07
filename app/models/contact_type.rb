# app/models/contact_type.rb
class ContactType < ApplicationRecord
  validates_presence_of :name

  def json
    {
      'id': id,
      'name': name
    }
  end

  def to_csv
    [name]
  end
end
