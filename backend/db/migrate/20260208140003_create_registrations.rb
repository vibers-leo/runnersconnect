# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :race_edition, null: false, foreign_key: true
      t.integer :crew_id # Optional for now
      
      t.string :merchant_uid, null: false # Payment ID
      t.string :status, default: 'pending' # pending, paid, cancelled, refunded
      
      t.string :payment_method 
      t.integer :payment_amount
      t.datetime :paid_at
      
      t.string :bib_number
      t.string :tshirt_size
      
      t.string :shipping_status, default: 'preparing'
      t.string :tracking_number
      t.string :qr_token
      
      t.jsonb :shipping_address_snapshot # Snapshot of address at the time of order

      t.timestamps
    end
    
    add_index :registrations, :merchant_uid, unique: true
    add_index :registrations, [:user_id, :race_edition_id], unique: true # Prevent duplicate registration
  end
end
