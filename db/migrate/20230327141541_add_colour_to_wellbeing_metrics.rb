class AddColourToWellbeingMetrics < ActiveRecord::Migration[6.1]
  def change
    add_column :wellbeing_metrics, :colour, :string
  end
end
