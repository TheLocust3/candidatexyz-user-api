class AddElectionDateToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :election_day, :datetime
  end
end
