# frozen_string_literal: true

class AddPostcodeToWellbeingServices < ActiveRecord::Migration[6.1]
  def change
    add_column :wellbeing_services, :postcode, :string
    add_column :wellbeing_services, :address, :string
    add_column :wellbeing_services, :longitude, :float
    add_column :wellbeing_services, :latitude, :float
  end
end
