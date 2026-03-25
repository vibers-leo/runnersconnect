class CreateSettlements < ActiveRecord::Migration[8.1]
  def change
    create_table :settlements do |t|
      t.references :organizer_profile, null: false, foreign_key: true, index: true
      t.references :race, null: false, foreign_key: true, index: true
      t.string :status, default: 'pending', null: false
      t.integer :registration_count, default: 0
      t.decimal :total_revenue, precision: 15, scale: 2, default: 0
      t.decimal :platform_commission, precision: 15, scale: 2, default: 0
      t.decimal :organizer_payout, precision: 15, scale: 2, default: 0
      t.datetime :requested_at
      t.datetime :approved_at
      t.datetime :paid_at
      t.text :admin_memo

      t.timestamps
    end

    add_index :settlements, [:organizer_profile_id, :race_id], unique: true
    add_index :settlements, :status
  end
end
