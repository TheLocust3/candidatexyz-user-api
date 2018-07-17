class AddBanktoCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :committees, :bank, :string
  end
end
