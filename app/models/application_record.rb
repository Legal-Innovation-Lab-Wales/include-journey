# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created
    created_at.strftime('%d/%m/%Y %I:%M %p')
  end

  def last_update
    updated_at.strftime('%d/%m/%Y %I:%M %p')
  end
end
