class AddCampaignKey < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :campaign, type: :uuid, null: false
  end
end
