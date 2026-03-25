class AddEmergencyContactToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :emergency_contact, :string
  end
end
