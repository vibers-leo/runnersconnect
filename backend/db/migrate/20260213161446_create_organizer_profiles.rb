class CreateOrganizerProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :organizer_profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :business_name, null: false
      t.string :contact_email
      t.string :contact_phone
      t.text :description

      # Settlement information
      t.string :bank_name
      t.string :bank_account
      t.string :account_holder

      # Statistics
      t.integer :total_races_count, default: 0
      t.integer :total_participants_count, default: 0

      t.timestamps
    end
  end
end
