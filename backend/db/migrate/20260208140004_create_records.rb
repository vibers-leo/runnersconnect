# frozen_string_literal: true

class CreateRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :race_edition, null: false, foreign_key: true
      t.references :registration # Optional (could be external record)
      
      t.string :net_time # e.g. "01:05:30"
      t.string :gun_time
      
      t.integer :rank_overall
      t.integer :rank_gender
      t.integer :rank_age
      
      t.jsonb :splits # { "5k": "00:25:00", "10k": "00:50:00" }
      t.string :certificate_url
      t.jsonb :photo_urls # [ "url1", "url2" ]
      
      t.boolean :is_verified, default: true

      t.timestamps
    end
    
    add_index :records, [:user_id, :race_edition_id], unique: true
  end
end
