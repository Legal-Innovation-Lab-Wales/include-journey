# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # after_validation :failed_validation

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

  def been_updated?
    created_at != updated_at
  end

  def approved_date
    if approved_at.nil?
      'Not Yet Approved'
    else
      approved_at.strftime('%d/%m/%Y %I:%M %p')
    end
  end

  # def failed_validation
  #  return unless errors.present?

  #  puts '', "Errors found in validation for: #{errors.attribute_names}"
  #  errors.attribute_names.each do |err|
  #    puts "#{err}: #{attributes[err.to_s]}"
  #  end
  # end
end
