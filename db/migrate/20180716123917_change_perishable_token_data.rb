class ChangePerishableTokenData < ActiveRecord::Migration[5.1]
  def change
    remove_column :perishable_tokens, :data
    add_column :perishable_tokens, :data, :json
  end
end
