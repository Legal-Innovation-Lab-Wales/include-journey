# app/models/wba_score.rb
class WbaScore < ApplicationRecord
  belongs_to :wellbeing_assessment
  belongs_to :wellbeing_metric
  belongs_to :wellbeing_score_value, foreign_key: :value

  def add_to_history(history)
    existing_dataset = history[:datasets].find { |dataset| dataset[:label] == wellbeing_metric.name }

    if existing_dataset.present?
      existing_dataset[:data] << point
    else
      history[:datasets].push({label: wellbeing_metric.name, data: [point]})
    end
  end

  def point
    {x: created_at, y: value}
  end
end
