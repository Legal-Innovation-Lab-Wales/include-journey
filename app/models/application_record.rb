# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def created
    created_at.strftime('%d/%m/%Y %I:%M %p')
  end

  def created_date
    created_at.strftime('%d/%m/%Y')
  end

  def created_time
    created_at.strftime('%I:%M %p')
  end

  def last_update
    updated_at.strftime('%d/%m/%Y %I:%M %p')
  end
end
