class RemoveUserCampaignIdNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null :users, :campaign_id, true
  end
end
