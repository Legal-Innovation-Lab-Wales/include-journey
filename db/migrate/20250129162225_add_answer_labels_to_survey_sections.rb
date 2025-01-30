class AddAnswerLabelsToSurveySections < ActiveRecord::Migration[6.1]
  def change
    add_column :survey_sections, :answer_labels, :string
  end
end
