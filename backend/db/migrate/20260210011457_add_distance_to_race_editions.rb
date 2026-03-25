class AddDistanceToRaceEditions < ActiveRecord::Migration[8.1]
  def change
    add_column :race_editions, :distance, :float
  end
end
