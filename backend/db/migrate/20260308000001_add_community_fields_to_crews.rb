class AddCommunityFieldsToCrews < ActiveRecord::Migration[8.1]
  def change
    add_column :crews, :slug, :string
    add_column :crews, :short_description, :string
    add_column :crews, :region, :string
    add_column :crews, :founded_year, :integer
    add_column :crews, :member_count_estimate, :integer
    add_column :crews, :activity_schedule, :string
    add_column :crews, :activity_location, :string
    add_column :crews, :status, :integer, default: 0, null: false
    add_column :crews, :featured, :boolean, default: false, null: false
    add_column :crews, :website_url, :string
    add_column :crews, :published_at, :datetime
    add_column :crews, :views_count, :integer, default: 0, null: false

    add_index :crews, :slug, unique: true
    add_index :crews, :status
    add_index :crews, :region
    add_index :crews, :featured
  end
end
