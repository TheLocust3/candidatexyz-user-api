class AddUrlToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :url, :string
  end
end
