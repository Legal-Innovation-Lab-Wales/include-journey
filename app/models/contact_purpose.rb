# app/models/contact_purpose.rb
class ContactPurpose < ApplicationRecord
  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
