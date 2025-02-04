# frozen_string_literal: true

# db/migrate/20210407142951_create_metrics_services.rb
class CreateMetricsServices < ActiveRecord::Migration[6.1]
  def change
    create_table :metrics_services do |t|
      t.belongs_to :wellbeing_service, null: false, foreign_key: true
      t.belongs_to :wellbeing_metric, null: false, foreign_key: true

      t.timestamps
    end
  end
end
