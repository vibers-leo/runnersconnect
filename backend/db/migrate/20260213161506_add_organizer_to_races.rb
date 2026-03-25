class AddOrganizerToRaces < ActiveRecord::Migration[8.1]
  def change
    add_reference :races, :organizer, foreign_key: { to_table: :organizer_profiles }, index: true
  end
end
