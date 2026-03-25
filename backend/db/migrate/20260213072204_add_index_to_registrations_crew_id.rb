class AddIndexToRegistrationsCrewId < ActiveRecord::Migration[8.1]
  def change
    add_index :registrations, :crew_id
  end
end
