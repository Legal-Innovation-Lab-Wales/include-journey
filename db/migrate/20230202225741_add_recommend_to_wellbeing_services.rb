# frozen_string_literal: true

class AddRecommendToWellbeingServices < ActiveRecord::Migration[6.1]
  def change
    add_column :wellbeing_services, :recommend, :boolean
  end
end
