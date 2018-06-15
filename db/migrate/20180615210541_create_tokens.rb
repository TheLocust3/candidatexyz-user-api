class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :perishable_tokens, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :data
      t.datetime :good_until

      t.timestamps
    end
  end
end
