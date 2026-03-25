class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :race, null: false, foreign_key: true, index: true
      t.string :order_number, null: false
      t.string :status, default: 'pending', null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.text :shipping_address
      t.string :shipping_phone
      t.string :tracking_number

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :status
  end
end
