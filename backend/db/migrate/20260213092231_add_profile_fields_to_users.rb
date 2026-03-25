class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :region, :string
    add_column :users, :age_group, :string
    add_column :users, :onboarding_completed, :boolean, default: false, null: false
    add_index :users, :nickname, unique: true
  end
end
