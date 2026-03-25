class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.references :race, null: false, foreign_key: true, index: true
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0, null: false
      t.string :status, default: 'active', null: false
      t.string :size
      t.string :color

      t.timestamps
    end

    add_index :products, :status
  end
end
