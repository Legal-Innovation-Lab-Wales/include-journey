# app/models/wba_self_score.rb
class WbaScore < ApplicationRecord
  belongs_to :wellbeing_assessment
  belongs_to :wellbeing_metric

  # rubocop:disable Metrics/AbcSize
  def add_to_history(history)
    existing_dataset = history[:datasets].find { |dataset| dataset[:label] == wellbeing_metric.name }

    padding = ([nil] * ((history[:labels].length - 1) - (existing_dataset.present? ? existing_dataset[:data].length : 0)))

    if existing_dataset.present?
      existing_dataset[:data].concat(padding.push(value))
    else
      history[:datasets].push({ label: wellbeing_metric.name, data: padding.push(value) })
    end
  end
end
