class CreateCrawlSources < ActiveRecord::Migration[8.1]
  def change
    create_table :crawl_sources do |t|
      t.string :name, null: false
      t.string :base_url, null: false
      t.string :crawler_class, null: false
      t.boolean :enabled, default: true, null: false
      t.datetime :last_crawled_at
      t.integer :crawl_interval_hours, default: 24, null: false
      t.text :last_error

      t.timestamps
    end
  end
end
