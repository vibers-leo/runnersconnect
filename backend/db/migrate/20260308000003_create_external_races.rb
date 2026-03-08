class CreateExternalRaces < ActiveRecord::Migration[8.1]
  def change
    create_table :external_races do |t|
      t.string :title, null: false
      t.text :description
      t.date :race_date, null: false
      t.date :race_end_date
      t.string :location
      t.string :source_url, null: false
      t.string :source_name, null: false
      t.string :registration_url
      t.date :registration_deadline
      t.string :distances, array: true, default: []
      t.string :fee_info
      t.string :organizer_name
      t.string :image_url
      t.integer :status, default: 0, null: false
      t.datetime :crawled_at
      t.jsonb :raw_data, default: {}
      t.string :content_hash

      t.timestamps
    end

    add_index :external_races, :source_url, unique: true
    add_index :external_races, :race_date
    add_index :external_races, :status
    add_index :external_races, :source_name
  end
end
