# app/models/contact_purpose.rb
class ContactPurpose < ApplicationRecord
  validates_presence_of :name

  def json
    {
      'name': name,
    }
  end

  def to_csv
    [name]
  end
end
