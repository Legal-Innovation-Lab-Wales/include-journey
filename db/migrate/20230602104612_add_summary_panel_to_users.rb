class AddSummaryPanelToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :summary_panel, :text
  end
end
