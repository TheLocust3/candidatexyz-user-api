class AddPreliminaryDateToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :preliminary_day, :datetime
  end
end
