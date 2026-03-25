class AddShippingInfoToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :shipping_zipcode, :string
    add_column :registrations, :shipping_address, :string
    add_column :registrations, :shipping_address_detail, :string
    add_column :registrations, :shipping_phone, :string
    add_column :registrations, :shipping_memo, :text
  end
end
