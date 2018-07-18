class AddPartyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :party, :string, default: 'None', null: false
  end
end
