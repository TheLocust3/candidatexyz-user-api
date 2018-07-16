class CreateCommittee < ActiveRecord::Migration[5.1]
  def change
    create_table :committees, id: :uuid, default: "uuid_generate_v4()" do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false

      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false

      t.string :office, null: false
      t.string :district, null: false

      t.timestamps
    end

    add_reference :committees, :campaign, type: :uuid, null: false
  end
end
