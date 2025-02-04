# frozen_string_literal: true

# app/models/permission_record.rb
class PermissionRecord < ApplicationRecord
  self.abstract_class = true

  def permissions
    raise 'Subclass has not overridden permissions function'
  end
end
