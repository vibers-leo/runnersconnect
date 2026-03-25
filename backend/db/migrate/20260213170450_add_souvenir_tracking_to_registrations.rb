class AddSouvenirTrackingToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :souvenir_received_at, :datetime
    add_column :registrations, :souvenir_received_by, :string
    add_column :registrations, :medal_received_at, :datetime
    add_column :registrations, :medal_received_by, :string
    add_index :registrations, :souvenir_received_at
    add_index :registrations, :medal_received_at
  end
end
