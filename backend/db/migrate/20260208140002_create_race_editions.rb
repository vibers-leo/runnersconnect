# frozen_string_literal: true

class CreateRaceEditions < ActiveRecord::Migration[8.1]
  def change
    create_table :race_editions do |t|
      t.references :race, null: false, foreign_key: true
      t.string :name, null: false # 5K, 10K, Half, etc
      t.integer :price, null: false, default: 0
      t.integer :capacity, default: 0 # 0 means unlimited
      t.integer :current_count, default: 0
      t.integer :display_order, default: 1
      t.integer :age_limit_min
      t.integer :age_limit_max
      t.boolean :is_sold_out, default: false

      t.timestamps
    end
    

  end
end
