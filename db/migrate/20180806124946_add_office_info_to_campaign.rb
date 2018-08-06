class AddOfficeInfoToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :city, :string
    add_column :campaigns, :state, :string
    add_column :campaigns, :country, :string, default: 'United States'
    add_column :campaigns, :office_type, :string
  end
end
