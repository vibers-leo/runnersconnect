class CreateCrewContactPoints < ActiveRecord::Migration[8.1]
  def change
    create_table :crew_contact_points do |t|
      t.references :crew, null: false, foreign_key: true
      t.integer :platform, null: false, default: 0
      t.string :url, null: false
      t.string :label, null: false
      t.boolean :primary, default: false, null: false

      t.timestamps
    end

    add_index :crew_contact_points, [:crew_id, :platform]
  end
end
