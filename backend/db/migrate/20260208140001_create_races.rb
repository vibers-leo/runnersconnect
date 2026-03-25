# frozen_string_literal: true

class CreateRaces < ActiveRecord::Migration[8.1]
  def change
    create_table :races do |t|
      t.string :title, null: false
      t.text :description
      t.string :location
      t.datetime :start_at, null: false
      t.datetime :registration_start_at
      t.datetime :registration_end_at
      t.datetime :refund_deadline
      t.string :thumbnail_url
      t.string :status, default: 'draft' # draft, open, closed, finished
      t.string :organizer_name
      t.string :official_site_url
      t.boolean :is_official_record, default: true

      t.timestamps
    end
    
    add_index :races, [:status, :start_at] # For listing
  end
end
